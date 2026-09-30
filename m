Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646BF50B8C6;
	Wed, 30 Sep 2026 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792184; cv=none; b=IePhICd5emTAZ2kakqLq2EU5+Med9tDVd/y/ZOQV2UkLSe1+w+Vn5+Sxsth73sW5GRNM+aOZ30MCuf8z2JrxDA3TXO9BFuehb/9UeX5TBVDTbKH+FMzqD2jHLK4jgjv1COj5oARu6gkqbsm6vmpVHmAMD/Yy2okYMXI6sWOKoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792184; c=relaxed/simple;
	bh=Nwnhl1pa9N0wOcSCCvj8hCqJncRNhJUdmvCCv9xDpbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1PFVZhpBPb8ie7sNvgfBGm4eel3pbDTCnXSQvfchetAkOcEm5n45vNN8BML5Inuko+LjAZWUwFx8dZYAUl+P3dUxUFUGjpu5uzwGqqbFrx/OOHzBqBkgX2EMIg/AK0xV5KOCetdQ4n9xwkPap4z6EvtdBNIHggy5mKi9daIgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsHWZy4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsHWZy4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFE81F000FF;
	Wed, 30 Sep 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792183;
	bh=WSE579FpBNWZai4sLqbVfhCdzmBJDQOsHchnkxZCEIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsHWZy4aueGvhyqoTEnio16O7cr3BX59SGgXA43S10yCdGMHvQG7j1S+xnNNCuoke
	 8y6bS4outD1sRS9+k7jYV2jrkDS3RechIsnM2Bgq41bNzJ5FIYQW5wuOpD+h53b4LI
	 4zZ9DOepaLksIELfLA86LKwWocFzbRbkSt9vV+Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 566/752] hwmon: (w83793) release probe data through kref
Date: Wed, 30 Sep 2026 17:27:16 +0200
Message-ID: <20260930152410.485297580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c702a5f18b780e477eccbbab558e590e9673e4cb upstream.

w83793_probe() initializes data->kref to manage the lifetime of the
driver data. The normal remove path drops the driver-owned reference
with kref_put(), while watchdog users take and release additional
references through the same kref.

However, the probe error path still frees data directly with kfree().
This bypasses the kref-managed lifetime and discards the initial
reference without a matching kref_put(), leaving the reference
accounting unbalanced.

Drop the probe-owned reference with kref_put() instead and let
w83793_release_resources() perform the final free, matching the normal
remove path.

This issue was found by manual code inspection.

Fixes: 5852f9609d21 ("hwmon: (w83793) Add watchdog functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260914073638.1662500-1-lgs201920130244@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83793.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1931,7 +1931,9 @@ exit_remove:
 	for (i = 0; i < ARRAY_SIZE(w83793_temp); i++)
 		device_remove_file(dev, &w83793_temp[i].dev_attr);
 free_mem:
-	kfree(data);
+	mutex_lock(&watchdog_data_mutex);
+	kref_put(&data->kref, w83793_release_resources);
+	mutex_unlock(&watchdog_data_mutex);
 exit:
 	return err;
 }


