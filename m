Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054623F075D;
	Mon, 17 Aug 2026 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976061; cv=none; b=MiI4ED26FaQnWf/oyyYN2kmgv9A0rC5Zpk33IXh07b//WAeIcetC5xg0hnkaNQ028RhPOLjXwCy2OWEa9DWSuXjZ4Phvd5Tl/e3FQyE8oFNQEpEOaoUNP/lTuYB/MhIlxnMZeLUFGT8eYEntPmyHMBq7IX953QN08DwU61urWqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976061; c=relaxed/simple;
	bh=soEuinUyevk2lUCorhVE4Bi6g72XB6mibvraKFmpJTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He8dCmLQnuCXmHmTv1UnHk7Rk+JSz9LOvwwW+dnzAse7qMOyebpQMbGenquxEUmbIx5mQvYEplmEBUpigGh9rEf8ko+Vt0H25w9VdFRxPxaTwSEmgDJBsmx1bkLgd8sqGxq9k3BkFJ9IRHbFUOtLKVxZQZZL+PgknYfdui2vQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsfFddYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsfFddYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6431F000E9;
	Mon, 17 Aug 2026 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976059;
	bh=WhC9TNnG54wPG1r9lgR2RLig5yXN7+Tef9l9miUj2WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsfFddYuzH2B5E8TDiVRlwmmEu8PDaoH09sqzF2W31C+VGNJmzkBsswzcUZ//vfIW
	 RkdbJgwpCF50ZBXvV2Sp+vdFJ19sR09zxf5F+0YIXFGM/StTMWJ8iK0wmIvkaYdDJz
	 qDaOz6qGlciHwMwZN04RFYF+8lBIe2woJARvvqwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 244/389] sctp: validate Adaptation Indication parameter length
Date: Mon, 17 Aug 2026 15:31:23 +0200
Message-ID: <20260817132548.807293515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2142,7 +2142,13 @@ static enum sctp_ierror sctp_verify_para
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


