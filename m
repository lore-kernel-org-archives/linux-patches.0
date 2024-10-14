Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B983A1B6;
	Mon, 14 Oct 2024 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918485; cv=none; b=C6SZBn66UXJu4TzyrVoY/W85APGaRwk1GxIR4J7XHNIenLzP1Adud2GHLA1I2udam8BuUVDkiba3Jr05it9ewZz0+uZi97FptqYUiWxqO8Xjm/LkIEQvdk/rRnhcpQfnpiMNH4DFJRqQbQRbsNl2dclZkqSI+amHb0nGa1t6Ezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918485; c=relaxed/simple;
	bh=6t+5rp3YBCsMcFDwVoZFVNc30WWnhdqISPWXKPRf/IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaDi7s/FSdCLBQrrCTshKE0p5gKf9/8bhi/dfujJklyR60OULkzVni3pls+mXh77RVYiNmYf8gdiEUe8SQfKYh7Cl3cEQvkCTFsmaon7C6lXlgDEdLsbUlQ0gmEV3YxsfmFLSoD5eEN8cyoDbPuA5M2o9Ggj8eKhzmcRPMDtzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5CFdzrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5CFdzrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795CBC4CEC3;
	Mon, 14 Oct 2024 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918485;
	bh=6t+5rp3YBCsMcFDwVoZFVNc30WWnhdqISPWXKPRf/IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5CFdzrGo3LLu4iv0ys1IPhxHc3cJyGfSfdIRNQ8qyDXmZFnyz1917NwlWlqMkq82
	 s/A1G66R2B7PyNHqWbVRHKmtLZcCDkDW8AGcuyPkYtBRpbhgV5hq31tsRpluktsXto
	 2Ys6oTcRUf4RtYzM5941nyufsd7CN6LgGS8AEGKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.1 338/798] nfs: fix memory leak in error path of nfs4_do_reclaim
Date: Mon, 14 Oct 2024 16:14:52 +0200
Message-ID: <20241014141231.227488669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1953,6 +1953,7 @@ restart:
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
 				status = nfs4_recovery_handle_error(clp, status);
+				nfs4_free_state_owners(&freeme);
 				return (status != 0) ? status : -EAGAIN;
 			}
 


