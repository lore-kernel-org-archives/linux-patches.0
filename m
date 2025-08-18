Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042C35A292;
	Mon, 18 Aug 2025 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526436; cv=none; b=jma+9WJXX3O/NW0QZigwt6zu9c9zZS19nsRm3CPWuoMsXMzRd1+YzA8LHLjoiwC7k2hYlCHKZn1SqS4zA9d+DNNJdUtnIRgzP4Niq9vOt40VNEaJk3faQwz6z980LDwgt4gNKv0KSEFYP6GoRWqH8wIZWGAiy8FiJw/p6a9fDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526436; c=relaxed/simple;
	bh=8hvJSnKL8ZJbkGSBgULEbqGN3uYzcHbzfLHYWG0NRMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJfh6blvzbD44aS7+GpapXSVIuEe7bFlHIL6jAy6pelHws/WNzggcYPCE10naNbPJe4tfT4hDcc6VEcegHWMAQrfx1vUAeYxRGZ6QXv/vHT165U9R3z9hb/6krIILCeZUjujdA1IFSQ9cARgIpdAMLgIVhdE9klBcPMRnNWvHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+cDbPlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+cDbPlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFCFC4CEEB;
	Mon, 18 Aug 2025 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526436;
	bh=8hvJSnKL8ZJbkGSBgULEbqGN3uYzcHbzfLHYWG0NRMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+cDbPlWp/z82sQbfMLWrEIjjNFybWfX60K6ER/mfYwqK2h2qlcTlE6pQYSFZ/+Ai
	 oGkaQc+gr7w1OD0VsFlMYxlU0XOOxF/IhjGZt1AuqCNZEfs9pvh/kctAZDnzpz8rUm
	 MnFlAEmHqkSNsFHG53YJ5Xvzt/C15LzT4AizoTvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 522/570] btrfs: dont skip accounting in early ENOTTY return in btrfs_uring_encoded_read()
Date: Mon, 18 Aug 2025 14:48:29 +0200
Message-ID: <20250818124525.974587674@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

commit ea124ec327086325fc096abf42837dac471ac7ae upstream.

btrfs_uring_encoded_read() returns early with -ENOTTY if the uring_cmd
is issued with IO_URING_F_COMPAT but the kernel doesn't support compat
syscalls. However, this early return bypasses the syscall accounting.
Go to out_acct instead to ensure the syscall is counted.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
CC: stable@vger.kernel.org # 6.15+
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4829,7 +4829,8 @@ static int btrfs_uring_encoded_read(stru
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 		copy_end = offsetofend(struct btrfs_ioctl_encoded_io_args_32, flags);
 #else
-		return -ENOTTY;
+		ret = -ENOTTY;
+		goto out_acct;
 #endif
 	} else {
 		copy_end = copy_end_kernel;


