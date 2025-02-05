Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E1E188736;
	Wed,  5 Feb 2025 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768597; cv=none; b=UXqYV6zJDj9ISf3bu84j/PHTYsTzK39r9V1oN63szmVlEdXLQTu0QfAPZ9q2kYLH0gSJ0JG4lxbKrMSxKPCQ1oxiYHCZHgwH8bT5P8m/A2iW+eKYGtJhuy6LrwMN9zBkQxqAvgf15TYMk/q918ldetvJ0OQX1Ot+EzbdOaRvGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768597; c=relaxed/simple;
	bh=oc/RrMbKNvi1UBsEVWKbklY7STYdmYc1M/MNlBHV4qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVq8Ir9sIob2Uay20tPrxfC85uH5NHIzIFmQ48G5DFSgppWzdJaXDGtn1jxcTWFZjcGO3MEjuTkxHJoFIwkfpbS7PRKux/Xtw8jOJiN6xulRlycIaSYigHrLmIA0bl8ceKfsIuwOpcrkb4hw8wHV9hrdANnuf4G/+a9uH00Q2D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgi2rCis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgi2rCis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19600C4CED1;
	Wed,  5 Feb 2025 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768596;
	bh=oc/RrMbKNvi1UBsEVWKbklY7STYdmYc1M/MNlBHV4qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgi2rCisww935tt8i/0nvP5qpIwrN81DHwplSXWYO0BxtnOvPv0M3184lcAXh3KVy
	 RR7/aBtlfjKLGG3K2fqsO3n2EpIIR4XQo4kUFGRFzDn+KyrK34OdSm4E2KcbYWXZn0
	 GMONdl7nInREk9++/oT5mBso+pNJFeRR+vo27izc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 602/623] mptcp: blackhole only if 1st SYN retrans w/o MPC is accepted
Date: Wed,  5 Feb 2025 14:45:44 +0100
Message-ID: <20250205134519.252926829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e598d8981fd34470b78a1ae777dbf131b15d5bf2 upstream.

The Fixes commit mentioned this:

> An MPTCP firewall blackhole can be detected if the following SYN
> retransmission after a fallback to "plain" TCP is accepted.

But in fact, this blackhole was detected if any following SYN
retransmissions after a fallback to TCP was accepted.

That's because 'mptcp_subflow_early_fallback()' will set 'request_mptcp'
to 0, and 'mpc_drop' will never be reset to 0 after.

This is an issue, because some not so unusual situations might cause the
kernel to detect a false-positive blackhole, e.g. a client trying to
connect to a server while the network is not ready yet, causing a few
SYN retransmissions, before reaching the end server.

Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -405,9 +405,9 @@ void mptcp_active_detect_blackhole(struc
 			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPCAPABLEACTIVEDROP);
 			subflow->mpc_drop = 1;
 			mptcp_subflow_early_fallback(mptcp_sk(subflow->conn), subflow);
-		} else {
-			subflow->mpc_drop = 0;
 		}
+	} else if (ssk->sk_state == TCP_SYN_SENT) {
+		subflow->mpc_drop = 0;
 	}
 }
 


