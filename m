Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC8417B421;
	Wed,  2 Oct 2024 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877053; cv=none; b=tENnncybNaTzny3j/FW6viyiAc+UHHrBqgQ+hlDhiypn96+cqyNsKveoUKE3ahCPwUr2MApTDT/NQCEJegUhZNyfm0SC7173g8Jr6Y7wonQ+gjP+EaDcDY7KytRKRwtR6g33XJ6HyWeiBUFmFHtQDr98RfatYz5RqecvNzOBb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877053; c=relaxed/simple;
	bh=jFEcT2BiqlOp+Z866qWAkCEijr+ozE2V04BtC3aGNGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6erI7tPmhEYSi2uxs3AUw9PzrOMWaEHxZMDpJOaJaV/Kw7x5VK/Lbd9bqc8xgk/sfxAG+9NrF4yFlvxTbww/dQPM0FfWJhy6rH5NlGvpkVCmklMXpgKyh2mgnVwVyyHOTeU5Fp7u1fyF3dwBH9ahh5+Si1iU+pBEmpi3iSMzIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuI4JvM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuI4JvM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240E0C4CEC2;
	Wed,  2 Oct 2024 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877053;
	bh=jFEcT2BiqlOp+Z866qWAkCEijr+ozE2V04BtC3aGNGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuI4JvM5sCNCpJp+Ve1inhmzhPF7wfgP5NVKK+FcdORJWosiuZ0jMMK+Im4EdHtB3
	 FVg97QrwdqfjjCIu8XZ6CbI17JxdIMRInF42GtnYG5LdP+jrmfnrmQYFVID148LHGf
	 RNkFv1sh+ij55U+FbTJf5UreURuoJbAmeFY3CfRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.11 648/695] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Wed,  2 Oct 2024 15:00:46 +0200
Message-ID: <20241002125848.380249005@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

commit 8f6a7c9467eaf39da4c14e5474e46190ab3fb529 upstream.

Commit c77e22834ae9 ("NFSv4: Fix a potential sleep while atomic in
nfs4_do_reclaim()") separate out the freeing of the state owners from
nfs4_purge_state_owners() and finish it outside the rcu lock.
However, the error path is omitted. As a result, the state owners in
"freeme" will not be released.
Fix it by adding freeing in the error path.

Fixes: c77e22834ae9 ("NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1957,6 +1957,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


