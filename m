Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622C199FD7;
	Tue, 10 Sep 2024 10:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963614; cv=none; b=JinL8itLUNZQD65YEce9XJ0p8MZTtOBP3E//7LSKBszMqGtLrTuKK59OHQs3yNJ4NmmPFM1xplv3tAdAevjKN+T5ql5TZOqDDgS0VTYrl6z5eO5Bb1h75RrRNMxQTvX1Z9f8DhmC2VNPoHDQANQTmqb3YxldFfoZRRDnZoMkulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963614; c=relaxed/simple;
	bh=hKVtwCNrH8gUNfnH+XXY8uf9oQWUextMfmHB5PGWOtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHvAM4AItSMteo0aLqRZk4Sek7mjOlnDQWDRRDCrNm5dl86BPnHLGePowHGrUE6qQuWVl1oFNy7GjjDoeJ8oPbRXyNUB2k91j/hFtCRgZvgataI+ibo1QvaqESltpm/Wbn7T6xxEuSWXwFMN2htQs2/I2J25mCeohnH993yG3nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfY39Cs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfY39Cs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F162CC4CEC3;
	Tue, 10 Sep 2024 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963614;
	bh=hKVtwCNrH8gUNfnH+XXY8uf9oQWUextMfmHB5PGWOtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfY39Cs4D/EvVgHm3YJkQXYorKMgPPdAgMavHCPUv11UdTOPBA++EGiYAH/O/lz11
	 b0UcLMsZf37YDLKotPSWlHb75CXwcgIwyvuzTDSFRIgAb/h0W56JDMUjOAxoVgqiYH
	 2om3f4ZsPe91MoueqfQfwTFIUMNVVOWTKSdH607A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 091/214] mptcp: pm: only decrement add_addr_accepted for MPJ req
Date: Tue, 10 Sep 2024 11:31:53 +0200
Message-ID: <20240910092602.491626009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 1c1f721375989579e46741f59523e39ec9b2a9bd upstream.

Adding the following warning ...

  WARN_ON_ONCE(msk->pm.add_addr_accepted == 0)

... before decrementing the add_addr_accepted counter helped to find a
bug when running the "remove single subflow" subtest from the
mptcp_join.sh selftest.

Removing a 'subflow' endpoint will first trigger a RM_ADDR, then the
subflow closure. Before this patch, and upon the reception of the
RM_ADDR, the other peer will then try to decrement this
add_addr_accepted. That's not correct because the attached subflows have
not been created upon the reception of an ADD_ADDR.

A way to solve that is to decrement the counter only if the attached
subflow was an MP_JOIN to a remote id that was not 0, and initiated by
the host receiving the RM_ADDR.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-9-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c, because the context is different, but the
  same lines can still be modified. The conflicts are due to commit
  4d25247d3ae4 ("mptcp: bypass in-kernel PM restrictions for non-kernel
  PMs") and commit a88c9e496937 ("mptcp: do not block subflows creation
  on errors"), adding new features and not present in this version.
  Note that because some features to better track subflows are missing
  in this version, it is required to remove the WARN_ON, because the
  counter could be 0 in some cases. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -757,7 +757,7 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
-			removed = true;
+			removed |= subflow->request_join;
 			msk->pm.subflows--;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW)
 				__MPTCP_INC_STATS(sock_net(sk), rm_type);
@@ -767,7 +767,11 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 		if (!removed)
 			continue;
 
-		if (rm_type == MPTCP_MIB_RMADDR) {
+		if (rm_type == MPTCP_MIB_RMADDR && rm_list->ids[i] &&
+		    msk->pm.add_addr_accepted != 0) {
+			/* Note: if the subflow has been closed before, this
+			 * add_addr_accepted counter will not be decremented.
+			 */
 			msk->pm.add_addr_accepted--;
 			WRITE_ONCE(msk->pm.accept_addr, true);
 		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {


