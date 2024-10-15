Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F91D515A;
	Tue, 15 Oct 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998407; cv=none; b=fh7KVRlei4stOzzPn9KCeBKEf3mWE8mrBmNqlRQ3WFBdDY5vHyXcqkxuEUx7CKoyh/v5C7se1tpFQ+wmHaqL7niigeAJ46wyfN0HrcrmWVk6Zh1Vx/yCE9NWnLNH6oRWPWZMfoy/ywCM7jVuPWGgyekxM7Zyak/30VnrcmD12Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998407; c=relaxed/simple;
	bh=+yW3PJY+yx09FaKMTZ2iRiKRzDlmWATqOh5N6Bvl2ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJqSdkzAhEFajxh6/hCJUDcD++1VZ3glnoWnF49tYchP1ZsCvBbqnWMgZScSFu27S9smK+ul1ksgWdS6d37NHqPINuvWDnpHCsTMBahsHrwy2FCsWLw89Ys3ynqy/6nEyzuJ9d5rojv9qAs4en4aIchsVWdOYh4oe+fiHYlNMFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXHsfJNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXHsfJNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BB3C4CED0;
	Tue, 15 Oct 2024 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998407;
	bh=+yW3PJY+yx09FaKMTZ2iRiKRzDlmWATqOh5N6Bvl2ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXHsfJNe40sHaHN3jd/dtz4Mrs8E2u7v0L2I8YWsmNJ9XWQTOHy0lhm9aORHj1EeF
	 In4ZaYdvY3amVBvhUIHOjPmNy4ENMnbJ1VgGVLDVjv4CGlh7bCSXobvJ6z/yYusE68
	 KUce52KY6Yky23w4KdHoZmRBj5YfoEoxyVBtPODI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/518] tools/iio: Add memory allocation failure check for trigger_name
Date: Tue, 15 Oct 2024 14:46:11 +0200
Message-ID: <20241015123935.029946064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 3c6b818b097dd6932859bcc3d6722a74ec5931c1 ]

Added a check to handle memory allocation failure for `trigger_name`
and return `-ENOMEM`.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240828093129.3040-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 2fd10eab75b53..5ef09ac6e7cf7 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -479,6 +479,10 @@ int main(int argc, char **argv)
 			return -ENOMEM;
 		}
 		trigger_name = malloc(IIO_MAX_NAME_LENGTH);
+		if (!trigger_name) {
+			ret = -ENOMEM;
+			goto error;
+		}
 		ret = read_sysfs_string("name", trig_dev_name, trigger_name);
 		free(trig_dev_name);
 		if (ret < 0) {
-- 
2.43.0



