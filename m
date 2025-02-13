Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7302E26B087;
	Thu, 13 Feb 2025 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460721; cv=none; b=lFGrahFuR38Nkstp8/XxLimmrV675zpK7Ji3ds3Fco1CFZkBRR7j9C0TKwp4j9aHan4Lycn/KuOsJ51hytR9E1koI/on23bGsJzr4SaJRUkuQ1KCxw/Thm11p5Up9ZjoF6UvyYrZUYBE7sWv+5kJqchmj3OhO4B2PmUsuOTMPSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460721; c=relaxed/simple;
	bh=NokA/H6D63UNk+f51zkfN7/i3AYXkVt4T21PejzBk+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI26dtn8pdEa0Uc+4TRy9V3upCsM9rT0nN1hu+ylM7uksPnc57YZMWo7EKAT0VB0gArQ8mjLCOMcU33Ap4Efd5wGLwUhy1tQa66ClkXzUOlPDt5r60kKvQ0TJ0xrr0zX62aUaEjabx4To+SbFKfM9OHOR+AOboHWD7cUf24GO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltmGWxes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltmGWxes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B641C4CED1;
	Thu, 13 Feb 2025 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460721;
	bh=NokA/H6D63UNk+f51zkfN7/i3AYXkVt4T21PejzBk+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltmGWxesgjAFd5hq+9iilx0QLY0vdLcp8nI8RDWQI/ykM43aocPBKQMCV8bk4+bkQ
	 SwORvdgaUdXslM/kxgj3RkTNSGg/K8l7cYbZd2PdDPGsTIA1lG52IjC/Z09RD4FgsQ
	 Y2oZC5AE4ms8TWULld++DW5hd+vFA+Jfn3GUVYVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 193/273] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
Date: Thu, 13 Feb 2025 15:29:25 +0100
Message-ID: <20250213142414.950659009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fb95897b8c60653805aa09daec575ca30983f768 upstream.

In xfs_dax_write_iomap_end(), directly return the result of
xfs_reflink_cancel_cow_range() when !written, ensuring proper
error propagation and improving code robustness.

Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
Cc: stable@vger.kernel.org # v6.0
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -923,10 +923,8 @@ xfs_dax_write_iomap_end(
 	if (!xfs_is_cow_inode(ip))
 		return 0;
 
-	if (!written) {
-		xfs_reflink_cancel_cow_range(ip, pos, length, true);
-		return 0;
-	}
+	if (!written)
+		return xfs_reflink_cancel_cow_range(ip, pos, length, true);
 
 	return xfs_reflink_end_cow(ip, pos, written);
 }


