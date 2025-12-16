Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A073659FC;
	Tue, 16 Dec 2025 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887191; cv=none; b=HuVdFrgPe/VrxgEDdar9aPStYlm0+P/PqLiCRfxGwl8ooAmN3YVgDKC6xBbGNpJepbi2PtyygwuzHrE9FKLyO1aSDGKkoxuk85HyK8aeemcX8OitMKaqEoylVPkLzEmi197ZTham3jKN8Da+/J74E5bqfZUPDic0yzciQOP1nu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887191; c=relaxed/simple;
	bh=HomRJGJ/sTMkgf+OLUzbfQsM35kJ6kxcYhibL3EXCpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt1oTCeChUINkzbUAjRXZrrZZHhl61a9PrCtpvEd2kIK6JCx9YUeOg9/yH3vSzuHmkBb7k6tsL6gsK2KZglZPvwXj5WCqPziigDNVy4BZcEIAi7892u25WA6jqUkMmpauMncpnYpZJunLX1n2Iovm6LJ+0cODNCREmcR1/rp+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXSCZzkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXSCZzkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D2C4CEF1;
	Tue, 16 Dec 2025 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887191;
	bh=HomRJGJ/sTMkgf+OLUzbfQsM35kJ6kxcYhibL3EXCpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXSCZzkC/LnTFb9lyhCuQPPw/1YTBBmyYPeCiT8oMyB5y/sVkWvf+b4yMirDLhzGc
	 ws2kgmuZ5rhFhF0rDc/+dWu19tqAJNFYambWvbMXD33Ka+zxniXKPyWX3FoD1lUwNq
	 RZAHlnL45X/elthBhGxW6CqCv3IDdmZEFTYV6A4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/614] pidfs: add missing BUILD_BUG_ON() assert on struct pidfd_info
Date: Tue, 16 Dec 2025 12:08:41 +0100
Message-ID: <20251216111406.915819414@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit d8fc51d8fa3b9894713e7eebcf574bee488fa3e1 ]

Validate that the size of struct pidfd_info is correctly updated.

Link: https://patch.msgid.link/20251028-work-coredump-signal-v1-4-ca449b7b7aa0@kernel.org
Fixes: 1d8db6fd698d ("pidfs, coredump: add PIDFD_INFO_COREDUMP")
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 0ef5b47d796a2..f4d7dac1b4494 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -306,6 +306,8 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	const struct cred *c;
 	__u64 mask;
 
+	BUILD_BUG_ON(sizeof(struct pidfd_info) != PIDFD_INFO_SIZE_VER1);
+
 	if (!uinfo)
 		return -EINVAL;
 	if (usize < PIDFD_INFO_SIZE_VER0)
-- 
2.51.0



