Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F204C35335B;
	Tue, 26 Aug 2025 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216823; cv=none; b=DARKkPInqHB+9PpjaMlo0mtY3CSqjBjKnPNckqSbOf6WM7qZImPVGas4E7PvSGuQFbuKQYReEjBTa7mcFq2VZldat2zUn1sGIsY0QREPGKKDsQ79cDKxW+D40FAfCZXVSIBN2P1/tehjWk2mHRG3SrMqRugNBb+Mv5vbt6AQrGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216823; c=relaxed/simple;
	bh=hVG8rNhq9XqWd3RhVnCHyut3mhiuPbrJL6zWh2Dko8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+jrJntEDvuU06G4CR7kwPmBYsRORemvhm3sJ1M3jcWJ9rqsQIg9Zb10PCSlfHyMvhqjheX+zs/4lfmiUPa50VWf+eRWvto6RNPMAsfdUItHc2C4lgImhDx0Z8gFowHb1lliPkmdqQ8P7zb9nFV+4WPGDd+9M6VXGSL/IY7xf78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrhSSnUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrhSSnUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50373C4CEF1;
	Tue, 26 Aug 2025 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216822;
	bh=hVG8rNhq9XqWd3RhVnCHyut3mhiuPbrJL6zWh2Dko8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrhSSnUrQOTYsnF6eI1PItPZgjGZWlVEuGtMuPKMzYzv9SpdaOX2iQtWHIpW9tWnv
	 7rpAw6SJaR5j7kjrKttG01d8upkqRZHhlv5mw1vhNAA8tX03dMvYoka9x0LhE2byrG
	 o+WNP4bjCjHpxOMCRlPZgB45jvdGUe4Pn5HVnVQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 556/644] mptcp: fix error mibs accounting
Date: Tue, 26 Aug 2025 13:10:47 +0200
Message-ID: <20250826111000.307478533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 0c1f78a49af721490a5ad70b73e8b4d382465dae upstream.

The current accounting for MP_FAIL and FASTCLOSE is not very
accurate: both can be increased even when the related option is
not really sent. Move the accounting into the correct place.

Fixes: eb7f33654dc1 ("mptcp: add the mibs for MP_FAIL")
Fixes: 1e75629cb964 ("mptcp: add the mibs for MP_FASTCLOSE")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts, because commit f284c0c77321 ("mptcp: implement fastclose
  xmit path") is not in this version. That's OK, the new helper added
  by this commit doesn't need to be modified. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    1 +
 net/mptcp/subflow.c |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -793,6 +793,7 @@ static bool mptcp_established_options_mp
 	opts->fail_seq = subflow->map_seq;
 
 	pr_debug("MP_FAIL fail_seq=%llu\n", opts->fail_seq);
+	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFAILTX);
 
 	return true;
 }
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -963,10 +963,8 @@ static enum mapping_status validate_data
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		if (subflow->mp_join || subflow->valid_csum_seen) {
+		if (subflow->mp_join || subflow->valid_csum_seen)
 			subflow->send_mp_fail = 1;
-			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
-		}
 		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
 	}
 


