Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCBB1F1318;
	Wed,  6 Nov 2024 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898198; cv=none; b=ZIR5Cp26t1hO4TEMuk87CeBLtG2VExlWG+BsD/Z/NDCBc1JA5yWuu9nYSUacxLEq0dp4CfzPwIF9T4+/wHQO9UB97WEP2QVlZAmThQk5BDvPZ5k48M+OVxcZKXGcbAr1DGvpn9ZE3buBlBlZA4sBF/rdy8xu+jJ5wGjE+wHFVBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898198; c=relaxed/simple;
	bh=ihtkTfz+caRsKehdQT7bCLSeSCG4YPpt7PzlsFk6nb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmzq0jpj2vjQKuCiiAMDHw/epTKJEeG75rYsTlWUxQF7By5VfAQUk1nZyKPhylrhjBTW1DQHCX2RRYxzvT8Z5YrJXZIooCu6dL8rvtvvs0VFNutiG9rCdVj+Id3YwRWUhh8FZWV7ZcDH+mGjvYa7De0xQSkoacxG73A7fWAoUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XApE8GqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XApE8GqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5C2C4CECD;
	Wed,  6 Nov 2024 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898197;
	bh=ihtkTfz+caRsKehdQT7bCLSeSCG4YPpt7PzlsFk6nb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XApE8GqHBrPn4cHnnu5sb3WokT0s6rqHsqT1/1HDMhiOFAO8uKYgrNa7TdEe8bMme
	 XdWLffw+BIN+3se5k2eJ9TrAyrijFqyMJlCqJGyAXl2+qwcwtu7pLEix/l4GQ/CTgX
	 hc0CQeRk0LmsWaA1AG7NWwfP1we0eqbl+e8/6b08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 5.4 158/462] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Wed,  6 Nov 2024 13:00:51 +0100
Message-ID: <20241106120335.423872248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1900,6 +1900,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


