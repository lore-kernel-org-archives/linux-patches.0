Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA095172FA;
	Wed, 30 Sep 2026 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784918; cv=none; b=RJg9EJ6GtWhoKuGTht0nCLAvEW5STfmu4w/V8IFHnLRVne6IY00AhNSGrSPNn1+QLJXIsv/+gHepLX42KZ+liwCQ9P+vyW6C7mZzK3c7tXDalMfjdur/E/SqDl7f3G+mnpwctEqysw//FdlA/zIwgl9Ygc56UM3qev+7vcTKAWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784918; c=relaxed/simple;
	bh=ArK2dm0RCcxC/PYAZPpWgErB9nMsq3Xm8HHWrneh3ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjuFsqKD/roQX8L3ngL+LAm/SYM0OH6mHtO+EyxP3w6UQ8EE8rBI6aXmkWqjA/OrnOFzOItkrF2Rka05xp5k2Eh8ju9xvDDz4Bva2K5JwoEkMzP/RhBQT4wK6HvOgZl42zfgdOfxTTXK994ImfUaKggU0XS6XtAa006Aw9UK/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znwc+KR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znwc+KR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A03E1F00893;
	Wed, 30 Sep 2026 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784912;
	bh=tAyTCtzxkTyMtjDZX2KugopdDsmLWYuGtbaGRJflXlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Znwc+KR6b3JbVby7qGVJ3+UFDcoIXUpVyC1kfUTabJAUitEHsrm3Q29EpDKog+0cE
	 8xM1mEH53itKJS5DcRRmNn7/SI8qABud4Ifg7cufc1UGNYIJGhPgNZ9srU60NcQlse
	 tFT/7aqLkqorfN1hJAxFA4tX3ESKnX4Kw0ckYoUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jad Keskes <inasj268@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 323/982] EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation
Date: Wed, 30 Sep 2026 17:17:39 +0200
Message-ID: <20260930152423.757007949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jad Keskes <inasj268@gmail.com>

[ Upstream commit 66cc9dec919dd63d8e4b3d386f7aed3ae684e645 ]

The poll_msec sysfs store file uses simple_strtoul() which accepts an unsigned
long, but the target field (poll_msec) is unsigned int. On 64-bit systems,
a value > UINT_MAX is silently truncated when stored.

Fix the mismatch by using kstrtouint() instead. This rejects values larger
than UINT_MAX at parse time, making truncation impossible. Also add a check
for value < 1 to reject the 0-delay case, which would cause the poll work to
spin without delay and consume 100% CPU.

Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
Signed-off-by: Jad Keskes <inasj268@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260730145549.148229-1-inasj268@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_device_sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index ac678b4a21fcb..e2ee5c6c56d3b 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -90,14 +90,21 @@ static ssize_t edac_device_ctl_poll_msec_store(struct edac_device_ctl_info
 					*ctl_info, const char *data,
 					size_t count)
 {
-	unsigned long value;
+	unsigned int value;
+	int ret;
 
 	/* get the value and enforce that it is non-zero, must be at least
 	 * one millisecond for the delay period, between scans
 	 * Then cancel last outstanding delay for the work request
 	 * and set a new one.
 	 */
-	value = simple_strtoul(data, NULL, 0);
+	ret = kstrtouint(data, 0, &value);
+	if (ret < 0)
+		return ret;
+
+	if (value < 1)
+		return -EINVAL;
+
 	edac_device_reset_delay_period(ctl_info, value);
 
 	return count;
-- 
2.53.0



