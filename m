Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F240F2F5E;
	Tue, 12 Aug 2025 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021877; cv=none; b=ZkbUTjyddLqsI1HIV9Rr5mor3X+H5Da26wWjxQhRauwHZ6kV1Dwp/jlrMD1K3zNDwiYgTMaGrUmu00Qf/UjD5PiWjWEhB2W2NvuARcD+IZiHNaKownQ+JInD8dCqBfh9FSQIOzc9dYn9MJ/W61CSX/1vd5MhLsj/WtOE8dYxgvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021877; c=relaxed/simple;
	bh=iD/sUoG6Zm6Yd3uhOBCPyI07YsCYkdzr5mRDw0x3DDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8fycZReJ2WkLKMKdGP1LAPtDIX8VyhlonQiRRxlgL7Pn3NRofgxfqPDv10hssl4O84ucwSfSj5DLM0MsB9KK9GGbbTz0/PEmm+1ScAO5CV7SBjiTiLPLSMccOH3kRdEgWfH50gqTlOavtU+Lp3ingeGAjBdfukFS7BKvnvjr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+Nmdpey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+Nmdpey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E700C4CEF0;
	Tue, 12 Aug 2025 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021876;
	bh=iD/sUoG6Zm6Yd3uhOBCPyI07YsCYkdzr5mRDw0x3DDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+NmdpeyksaxAZPlIZDmpcxU6cfJscmNJH46FKnJ2d0jSd3gGih9AzFZI2aBtp7T9
	 kjRx8csucGvh+5LXNU7JHzrRBfy97htEonCpqfEcGce355RaDPa+C7IQ1M8bAwYGy2
	 cilRiOQVPJ/UZe3iUBOHDs15KdkUJhjC0pkFcExw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Berman <quic_eberman@quicinc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.6 251/262] freezer,sched: Clean saved_state when restoring it during thaw
Date: Tue, 12 Aug 2025 19:30:39 +0200
Message-ID: <20250812173003.840229748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Elliot Berman <quic_eberman@quicinc.com>

commit 418146e39891ef1fb2284dee4cabbfe616cd21cf upstream.

Clean saved_state after using it during thaw. Cleaning the saved_state
allows us to avoid some unnecessary branches in ttwu_state_match.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231120-freezer-state-multiple-thaws-v1-2-f2e1dd7ce5a2@quicinc.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/freezer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -187,6 +187,7 @@ static int __restore_freezer_state(struc
 
 	if (state != TASK_RUNNING) {
 		WRITE_ONCE(p->__state, state);
+		p->saved_state = TASK_RUNNING;
 		return 1;
 	}
 


