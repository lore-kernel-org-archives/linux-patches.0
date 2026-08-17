Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260E2E7BD6;
	Mon, 17 Aug 2026 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979918; cv=none; b=e1z0XpxmPYdy8hgVbjUDJDAe9d60zjBDpME2djzSCSwk5brneZt8sS4yB/BtXhUeEjjoeG+CjejPWJSaVDMKG+NtIK75ZCZzi8WDEtHKTY4Kj/LjQHZ/7lNhR33Edgfv9zZDYxwdM2n3NL1f0IaW8PsvCyUbgmIU1RxocesUxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979918; c=relaxed/simple;
	bh=quhPsdGQaEWal51Z5CIExQgEMHpg/KFc0aiSy9Xytvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnvmlo2MuTRo0mwUmL18mhkJ7UsHRc48LRhpxzOKiNcwn5IlpJA/Rx0LYzRoBvO1Ey5B77uDz2NksjLoFeNHvMD2PJITcXikYEa/WDG0tQNzpqO+btrhSNWT2VtjOYwOXBJYYgRkGpVfjQLeuvkRzX0WqwKC7VhNQG2CdpZu164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0i+9/2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0i+9/2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD5D1F000E9;
	Mon, 17 Aug 2026 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979916;
	bh=c3+NRqS6N4oVn6bU39TbDCXOtNVJFFa/c5QHBTKHZe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0i+9/2Jm2SEvxmXojczMEAPXSwDynU62IoyM4BhluvZs04/rYR84CVzRhlEWm71/
	 Myp6Qv8/ZzHy7/Qa2V6N5QCDH9+WlkHtNCRZqou08s0Qntu/Oe1nebCXByuzccXkf0
	 XpCwtap37wKjEV2BOmfxQtshAspTb0dCkn5lL/NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 391/609] sctp: validate Adaptation Indication parameter length
Date: Mon, 17 Aug 2026 15:31:27 +0200
Message-ID: <20260817132557.325600646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Charles Vosburgh <trilobyte777@gmail.com>

commit 74b21f52c5c5a71a05c0ff70e513f4f04ff28b17 upstream.

The Adaptation Layer Indication parameter contains a fixed 32-bit
Adaptation Code Point after its parameter header. However,
sctp_verify_param() accepts a header-only parameter because the generic
parameter walker only requires the header to be present.

sctp_process_param() then reads adaptation_ind beyond the declared
parameter. When the malformed parameter is last in an INIT, the read
starts at the receive skb tail, and the value is copied into the state
cookie returned in the INIT ACK. This may disclose four receive-buffer
tail bytes.

Require the declared parameter length to match the fixed structure size
and abort the association through the existing invalid parameter length
path otherwise.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Charles Vosburgh <trilobyte777@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2187,7 +2187,13 @@ static enum sctp_ierror sctp_verify_para
 	case SCTP_PARAM_HEARTBEAT_INFO:
 	case SCTP_PARAM_UNRECOGNIZED_PARAMETERS:
 	case SCTP_PARAM_ECN_CAPABLE:
+		break;
 	case SCTP_PARAM_ADAPTATION_LAYER_IND:
+		if (ntohs(param.p->length) != sizeof(*param.aind)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
 		break;
 
 	case SCTP_PARAM_SUPPORTED_EXT:


