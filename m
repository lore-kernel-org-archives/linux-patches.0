Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91EA3A6B82;
	Fri,  4 Sep 2026 05:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498566; cv=none; b=pBUqmX8uMYYbKl7tn7sLY/wa8Cw3fZkrn3j+brfYWsCJXh9/REGVxc0sxpaWxAL4Dm5mDTnbCuOvIO8E0TtDgpHK68L/GVZ3tmuMAkBF2rlPfVXF3UQb7Rcfuiw6Zhs/WiB8fQxAquVHcSCne4tjQEdj314kzDHeIq2ynk2XLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498566; c=relaxed/simple;
	bh=RlxrDW2oqL1F2TPR40Pf4LHfvZtHFeQYAqWr/q2lXSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clPEpOiBKgl95iQOp/t2VFC+q4Y0ywkkPqYPKvm4tKUUomSjlpmoO29fFjEnqzzU2tQHgLyJpdh5HGfnRBL4PlJdY/DI9TXogDlF6rXVZ06xWz8d5wfpzVv4mBYb3eFGYbq8tcd8WSWNxxbDbRhgdQvl6G469ebYsjnEbZimI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzDQk2OU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzDQk2OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CACC1F00A3D;
	Fri,  4 Sep 2026 05:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498564;
	bh=NRIth315qUuRSxe6w65jn8HHRvSQH9JoDhr6nBmdkyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzDQk2OUvGVSDSyvPWMBOHAk6ckDF+PcaUB3ywH52b/3fcKags1GwTPnq6DrEQSHr
	 /RTUt6LtEkRV/JBjA5eKx0hol32sWu0DKG36xx+m3ZqoFpS6/7saTLsgSJ8xc4OHsF
	 sEjPxTOe+cyYTAdAMhZ3CZHX/LHGHCQixJ2t8JPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 7.2 107/713] usb: typec: hd3ss3220: fix VBUS regulator error message
Date: Fri,  4 Sep 2026 06:51:15 +0200
Message-ID: <20260904045806.232625176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 10ff55ff552b3bf1dadba03fcc430ea205fa2761 upstream.

hd3ss3220_regulator_control() enables the VBUS regulator when @on is
true and disables it when @on is false.  However, its error message uses
the opposite operation name, so an enable failure is reported as a
disable failure and vice versa.

Print the operation that was actually attempted.  Reporting the opposite
regulator operation on failures can mislead debugging of VBUS problems.

Fixes: 27fbc19e52b9 ("usb: typec: hd3ss3220: Enable VBUS based on role state")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/7A42A287B2B588D0+20260812094632.348581-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/hd3ss3220.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/hd3ss3220.c
+++ b/drivers/usb/typec/hd3ss3220.c
@@ -218,7 +218,7 @@ static void hd3ss3220_regulator_control(
 
 	if (ret)
 		dev_err(hd3ss3220->dev,
-			"vbus regulator %s failed: %d\n", on ? "disable" : "enable", ret);
+			"vbus regulator %s failed: %d\n", on ? "enable" : "disable", ret);
 }
 
 static void hd3ss3220_set_role(struct hd3ss3220 *hd3ss3220)


