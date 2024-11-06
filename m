Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19261D416E;
	Wed,  6 Nov 2024 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895148; cv=none; b=U02v2MKOAOGeu9gzgS1/0bw6PSfjHBHWitca7k7y9MS0WtaR+Vtr0ssHmillw6kGcy79i146hv9yyOl3lAM4k9n9LnfO2hTnLXHkkn8RuWhNdwnlUTgocrrZPyOvf8QpY+4P5xGb1IwYVJJQsvh8R/Sa8IPwjGssQ5YPMEn37tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895148; c=relaxed/simple;
	bh=ymTUNnPGf4G5zunatXFD8A1IJCijlZ4+KkRWmnX+waA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIACxj+5iJEZbDXZFyib37mLPvCBfm3ZpF7izCxhIarCMl+fSzY/EPB665GWAJ/jWmxfE1vj5MmYwNbznbcZerZqXCh+BX3zyZZ5D7y1/Ie9ePbmAV9HpwDdtwLa7hSZuAz8u1sZL2aeMO8hJGQk7d7ltuefvw0s9HWSbukSdX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRtpKbr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRtpKbr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51515C4CECD;
	Wed,  6 Nov 2024 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895148;
	bh=ymTUNnPGf4G5zunatXFD8A1IJCijlZ4+KkRWmnX+waA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRtpKbr266Se2OgkH59SGI1QTOn/f3MtFQ/8x5QU1Iug+C6R5gIVsvdNqASLxvzJD
	 e2ofOIK4T2G4ZTgf8H4NxScbFUE1kE/rQHgs2IGORY3dZ3X2bqfXqxCxIOfYF/AEDg
	 LUIkjJlr6e9shBOIEyZHHx032WA3zvcXA88RdaOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 4.19 120/350] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Wed,  6 Nov 2024 13:00:48 +0100
Message-ID: <20241106120323.870940763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1892,6 +1892,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


