Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1A185928;
	Sun,  1 Sep 2024 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209148; cv=none; b=ByvRQSurjauSIwMO1brq/aXPJcHUnPOkyUgee2tZDb6MyUckKC9Mfr62NbGxWYFEw1+Xf4cvdG37ffvMUO0Jr8vWmKR6MeN42hoS5XX16fTpj21Mi/H2oFOd+VIiQcgpnD9Rtm5o/AKiQJU8CEeCb+4VO5TuSVZq/T6E0Boa9wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209148; c=relaxed/simple;
	bh=ZNUXgUs6T12Ln74jgF/FIWdU41d0Xz+WSal0iIe12t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB3FYbysnijAwYfpQba5vria/U7qCmfmvJ4AMQ25tAxLk6B9wz2gXL9Kzg9klCRxvqRvEzwIjBkSuD5ZFQ0EEmwn76ywyf/GXpRqJAeE33iCsG7hHj/HkFOCaQ3QBFBPa2y4tXf6LkboHpjvihHtDp+EM/OW6cNsiuwdZOp/EFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z03Fagnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z03Fagnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3319C4CEC3;
	Sun,  1 Sep 2024 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209148;
	bh=ZNUXgUs6T12Ln74jgF/FIWdU41d0Xz+WSal0iIe12t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z03Fagnm1sfOUvpfeTJcKuOrBVBT1OGLefavT8lkgZc37jNtsZ43CmI4b6InRDe+u
	 fZgyZ4Y6ucYCK7DA5Sy6Dh79+Kj0ao/ZO+d8S+xRJcZkH2JfgI21/XVhD+9qa1tAwS
	 XYdWwOILd78XodRWSgHLkUUseJlXKUFrthRZS5v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 15/71] mptcp: pm: send ACK on an active subflow
Date: Sun,  1 Sep 2024 18:17:20 +0200
Message-ID: <20240901160802.464862098@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit c07cc3ed895f9bfe0c53b5ed6be710c133b4271c upstream.

Taking the first one on the list doesn't work in some cases, e.g. if the
initial subflow is being removed. Pick another one instead of not
sending anything.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -750,9 +750,12 @@ void mptcp_pm_nl_addr_send_ack(struct mp
 	    !mptcp_pm_should_rm_signal(msk))
 		return;
 
-	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
-	if (subflow)
-		mptcp_pm_send_ack(msk, subflow, false, false);
+	mptcp_for_each_subflow(msk, subflow) {
+		if (__mptcp_subflow_active(subflow)) {
+			mptcp_pm_send_ack(msk, subflow, false, false);
+			break;
+		}
+	}
 }
 
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,


