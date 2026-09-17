Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E454DDB40;
	Thu, 17 Sep 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660770; cv=none; b=J7dXboM0CvDWDtDsVuOeH+EyTOr0czcHifNc4oMoKVSFG8vWeUeJHjLkRqbWBRx7WdeMFnoNMrODNsRVo0tvqK2P0+txl9AYYUKzJiXiJgEq4ICorR11HZ8JS4HZijiOHjsYHxh+L27qXWrtoSYWYLGIDKhMJ5CVztHVA/iC4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660770; c=relaxed/simple;
	bh=NvRcizob9TVJhheQqUTXR3shaN0i5bpRsTBmur9LPzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6bSLmYc1u1AEg1/msaFa1JwGOW4ymxckUFzejILmkt1w8yjsa14WXOS8oRxAIYXKpxcdBVj6EZDhdnq9Oh710H0Atk02LHjbzD80x9i9sHoqRxDxbCHJvznIzNFBB5MPgSDGCK8HvpHb6Rd4p0ZngX5S/xYnkeDEi46cKEPl0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDg+8nHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDg+8nHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280C41F00893;
	Thu, 17 Sep 2026 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660768;
	bh=6gHofAlRXu3VAj9dgUXjs0oC2KYaPiL9/I6JjXmoA9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDg+8nHAFX4OIJCRiYjlmf0N/AnK1qq/ilqxyIsoLHfXQ/MAVbdJmYEUd3H9LT1NU
	 asxYaFe6TiG7MNuc+XbRCCucdCguExv9vmUszjEsnmuhHgxcU3s3JfhyZRCPOJSvzc
	 O2xUmclOwMyJ8YuIDUn8WuPRVkgHKtUFXIyAOQqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 664/733] xfs: fix replaying dirent removals into the temporary directory
Date: Thu, 17 Sep 2026 16:16:12 +0100
Message-ID: <20260917151409.232466518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e854f9a28b1fa08dfa5bf18ee4184fae90106180 upstream.

xrep_dir_replay_removename is the function that replays a directory
entry removal from sc->ip into the temporary directory so that when we
swap the contents of sc->tempip and sc->ip, the directory is correct.
LOLLM noticed that we were passing the wrong inode pointer into
xrep_dir_init_args.  It doesn't make sense to set rd->args.dp to
rd->args.dp so let's fix this.

Cc: stable@vger.kernel.org # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -721,7 +721,7 @@ xrep_dir_replay_removename(
 	const struct xfs_name	*name,
 	xfs_extlen_t		total)
 {
-	struct xfs_inode	*dp = rd->args.dp;
+	struct xfs_inode	*dp = rd->sc->tempip;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 


