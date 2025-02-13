Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EBE15689A;
	Thu, 13 Feb 2025 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458208; cv=none; b=ecjoVe3u7itSj1e/LDi3gRmNNzLA78Jx3vEtFIKk/564KAUU+rg5t1mtdD9jyBnI8sWLgNwslr09UX4u4i9QSgN0sLkGSWzmOdbXfN9R+tQcdPLhUhIA/+GY+eRE5FEC8lPv8PLfqfytREEtL1szVYdMFWMQ+3z2CuxRxnXNCnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458208; c=relaxed/simple;
	bh=0vHwjksDqkW8om+fFFTLHntlNHbHzX93hz8incbdms8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y74FPi+DBgWs2jNXnNWIaVak3HJq7HlwcsOk5yQvaugt+K/WMLj+QlzHEUyJ7omRADGEyrxicn6OiuaJY14q6fRRraUSlFRnRwIDgYPpl83ljrXPyFoL8eJeaK1SoJ7mO3LfSBgVMTO3YQSwm9Em7FY3Z3GJUV9xymhcGd5ThN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQGJsnC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQGJsnC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E8CC4CED1;
	Thu, 13 Feb 2025 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458207;
	bh=0vHwjksDqkW8om+fFFTLHntlNHbHzX93hz8incbdms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQGJsnC20U2jh/QVJqJq9TF8hFZRtQ8isjAmP8JaWJB24YPePT3uY8JusE8rrLLXD
	 E11APdWbFJlGo661ihsN305Tbhrq+/w2tOnUI+tnkgs2qxglxCQd/ba7GpoKAi97k6
	 6ZM1iLbrOs1uhLRQe6XLj0zg2ewoN/hC/zyoU1ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 301/422] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
Date: Thu, 13 Feb 2025 15:27:30 +0100
Message-ID: <20250213142448.156651676@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
@@ -942,10 +942,8 @@ xfs_dax_write_iomap_end(
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


