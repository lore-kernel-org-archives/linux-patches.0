Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF24179641;
	Wed,  3 Jul 2024 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004602; cv=none; b=mmnZ7fjFeJQphaCZE+wjkKF+T9xEKgd05JGHItQaszCFKvFu3rnGZip7+hWYBNWjUZG54slWMf0dC5VtzGUxqLsTs3ar7+4qwAYVqemiLYRc61/PZCN2vy4cwmAOykBZiLq5IJv1+r9UiMv5AciXeoIGT57TdLapZTImyFlEWFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004602; c=relaxed/simple;
	bh=pBGeHI98N7dF+pVRhZc01tfpc69FqshjSpiECqdHqHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltTD8+sIzDuct0P4iN1usxJbH7CEEiCS2xevAInG5+wrURjGerd4HZweePX+BjZsYguuAxXKDBiHXO75br0btkJWSp5C/jMx36ROnRIpqdHTz5s6k0MLvHk6tdkv1+23WCySB6Nbnh1xdI1NZ5mgRU8pM4bUdf2LWnKO0UC1BLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBOFRJYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBOFRJYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09990C2BD10;
	Wed,  3 Jul 2024 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004602;
	bh=pBGeHI98N7dF+pVRhZc01tfpc69FqshjSpiECqdHqHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBOFRJYhJofBqPXNQb0d3ynsO5EkMhYkBOGtTSIKai/YzL0jUVrUcgKey0qYm3IVe
	 g43E6ipVYBGR3vPLrdQWmIenPhbJS2NfqXXi+aKWamu4FpCq05c6mL0c0o93qsXFxw
	 W2RKiXBnjuvwxx6kEisWpBsHHmBy+PvLz2OLND+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	YonglongLi <liyonglong@chinatelecom.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 097/290] mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID
Date: Wed,  3 Jul 2024 12:37:58 +0200
Message-ID: <20240703102907.856223693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YonglongLi <liyonglong@chinatelecom.cn>

commit 6a09788c1a66e3d8b04b3b3e7618cc817bb60ae9 upstream.

The RmAddr MIB counter is supposed to be incremented once when a valid
RM_ADDR has been received. Before this patch, it could have been
incremented as many times as the number of subflows connected to the
linked address ID, so it could have been 0, 1 or more than 1.

The "RmSubflow" is incremented after a local operation. In this case,
it is normal to tied it with the number of subflows that have been
actually removed.

The "remove invalid addresses" MP Join subtest has been modified to
validate this case. A broadcast IP address is now used instead: the
client will not be able to create a subflow to this address. The
consequence is that when receiving the RM_ADDR with the ID attached to
this broadcast IP address, no subflow linked to this ID will be found.

Fixes: 7a7e52e38a40 ("mptcp: add RM_ADDR related mibs")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: YonglongLi <liyonglong@chinatelecom.cn>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-20240607-misc-fixes-v1-2-1ab9ddfa3d00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c because the commit 9f12e97bf16c ("mptcp:
  unify RM_ADDR and RM_SUBFLOW receiving"), and commit d0b698ca9a27
  ("mptcp: remove multi addresses in PM") are not in this version. To
  fix the issue, the incrementation should be done outside the loop: the
  same resolution has been applied here.
  The selftest modification has been dropped, because the modified test
  is not in this version. That's fine, we can test with selftests from a
  newer version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -427,10 +427,10 @@ void mptcp_pm_nl_rm_addr_received(struct
 		msk->pm.subflows--;
 		WRITE_ONCE(msk->pm.accept_addr, true);
 
-		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
-
 		break;
 	}
+
+	__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
 }
 
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)


