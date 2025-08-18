Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A7D34E1A8;
	Mon, 18 Aug 2025 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525807; cv=none; b=s+9NsJWShVVohSn7vZ0x54/epQKMWESAoIkgbwKyph5KOHSjH4KM9/Y1gkE0/tH6mksT6GK1hp3O7qS7kLNQoBYHjEPvCVYKu9cGr7Y2zXFOxfRFvwT0XU5/pDPspP7Ju9Td7QlRuuJ+n9UuT+Y3xcrGXx2bhv338smgil9ILNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525807; c=relaxed/simple;
	bh=uYhmn1CoT3N74GwgAS7RAyGGw8YG9ZE2qwyqXedRlf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4GGlAmqn1XgDZbu9yXAljfP35inLYTom3QMmKljnBdxa+ps/oQVA+D9+Ze55VUzgoM5u2tz0wScVsTzrY39wg/MzCEJ6O+DnCUe996ID6ypEtOwJA1tqOFcbljJfXWjee0g8Zoh5FqZnHCZtTrSGYvttwoh4YG9UyEn5vEVQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCnyRM6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCnyRM6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983ECC4CEEB;
	Mon, 18 Aug 2025 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525807;
	bh=uYhmn1CoT3N74GwgAS7RAyGGw8YG9ZE2qwyqXedRlf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCnyRM6KXl8Gcyl75DM+XrYrvMMY0xV5LFew9dc7TJAy1RWzQptuGus1ZletionVD
	 OR52K2FCp5Jaj/F/DOYxHbKW3A4qqxkZ11tyx32dD0inGhlntfG0i3uxOM1tDQlA+7
	 DXtfREnq8F1x3MjnP0jpdQReE9cxlSKQmwvtiqfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 371/570] fs/orangefs: use snprintf() instead of sprintf()
Date: Mon, 18 Aug 2025 14:45:58 +0200
Message-ID: <20250818124520.145503477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>

[ Upstream commit cdfa1304657d6f23be8fd2bb0516380a3c89034e ]

sprintf() is discouraged for use with bounded destination buffers
as it does not prevent buffer overflows when the formatted output
exceeds the destination buffer size. snprintf() is a safer
alternative as it limits the number of bytes written and ensures
NUL-termination.

Replace sprintf() with snprintf() for copying the debug string
into a temporary buffer, using ORANGEFS_MAX_DEBUG_STRING_LEN as
the maximum size to ensure safe formatting and prevent memory
corruption in edge cases.

EDIT: After this patch sat on linux-next for a few days, Dan
Carpenter saw it and suggested that I use scnprintf instead of
snprintf. I made the change and retested.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index e8e3badbc2ec..1c375fb65018 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -396,7 +396,7 @@ static ssize_t orangefs_debug_read(struct file *file,
 		goto out;
 
 	mutex_lock(&orangefs_debug_lock);
-	sprintf_ret = sprintf(buf, "%s", (char *)file->private_data);
+	sprintf_ret = scnprintf(buf, ORANGEFS_MAX_DEBUG_STRING_LEN, "%s", (char *)file->private_data);
 	mutex_unlock(&orangefs_debug_lock);
 
 	read_ret = simple_read_from_buffer(ubuf, count, ppos, buf, sprintf_ret);
-- 
2.39.5



