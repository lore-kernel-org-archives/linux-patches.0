Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF0A20126A;
	Mon, 18 Aug 2025 13:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522338; cv=none; b=XppTJm2l9D1mX28SOqXfDkQkWjfnzIKM7eBScq3h0qkRoX9sdShkE666rWiFf1CZ6EMozPBI424s+aFpaE+0HQKb7SMbSBGppI6T4XuipB0kaGzDipqKyBAqSdC9cgYq67wcLu2yOc5OMK4ojecIjvRLVHRes3oeI1x6fVxQoEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522338; c=relaxed/simple;
	bh=L5eURaOevlBzYlMkHLolnjBRMBxcLd6tlx3KWgv3qwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk25gPr0C+g/ltlOxBiRDIJBlG3nbzJw/DythDELqaRGzvN0EwonCWsxb0jfkqVkFtwywwAuo6VCERXUiQSh8HiAZRw523KJPiG2J32UFb52WlhtH3ekZiv4h6nEUECtUUJe3O8gBkvIfCXs7X5YNxNLK9ViZgpxgo7U7UYaKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSlXM3WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSlXM3WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1BCC4CEEB;
	Mon, 18 Aug 2025 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522338;
	bh=L5eURaOevlBzYlMkHLolnjBRMBxcLd6tlx3KWgv3qwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSlXM3WKXEeisGL7XIJY/POglWI3vqqXJsK7rtkH9rx4ndzC/dEhEtdkkcLAxLgQi
	 zYn0z/popFwVtmfE9EXsoK8RzJl8z+eOyd+11ADtP7y8dJNNsI2XEe3VMaH5ynH7aP
	 vGZzteaZMgNXYGl6k7fs5fCMJpfI14epSWgpdGpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/444] fs/orangefs: use snprintf() instead of sprintf()
Date: Mon, 18 Aug 2025 14:45:11 +0200
Message-ID: <20250818124459.650717391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b57140ebfad0..cd4bfd92ebd6 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -354,7 +354,7 @@ static ssize_t orangefs_debug_read(struct file *file,
 		goto out;
 
 	mutex_lock(&orangefs_debug_lock);
-	sprintf_ret = sprintf(buf, "%s", (char *)file->private_data);
+	sprintf_ret = scnprintf(buf, ORANGEFS_MAX_DEBUG_STRING_LEN, "%s", (char *)file->private_data);
 	mutex_unlock(&orangefs_debug_lock);
 
 	read_ret = simple_read_from_buffer(ubuf, count, ppos, buf, sprintf_ret);
-- 
2.39.5



