Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EC92D73B5;
	Mon, 13 Apr 2026 16:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096558; cv=none; b=AW7ooAjPAWWsoZ65sm+ZEL+4meJsNVEuItUZDi6UC49bsUVfO1zCb5C/ldwBOJOEri+2PCfIJ5ruKpiGnjSPyiOgidsIC6uE/4RG2prheyzEYlMfST+WnCvJDvnWet5T5duND+c7bQ8iBrijISHA8R5WIBMpjSWC9n8lKMNdc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096558; c=relaxed/simple;
	bh=vCo+4/jYpzy8EzcgZL6ywHE1cYRen3iwHPQwOgZjybY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3dEBBpID74/IhfhsDX3COfEc1NGjhVsnNoMPu09e0RP3stkY7QTCg3Wm0hGot8+DfazKt6rL3MOK/V5eguttDSOxRFelvkAJEao0HG3WV4P2huDvQLLpH+5HY+sOtFGPfE21qkqk+MC61dRmbeEUl+ciLBfuM3O8DquJWGE1gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTPdyQq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTPdyQq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A09FC2BCB0;
	Mon, 13 Apr 2026 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096557;
	bh=vCo+4/jYpzy8EzcgZL6ywHE1cYRen3iwHPQwOgZjybY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTPdyQq1tLevERCUzDKdLlXVzlsPbMT9OrPDDUe7+lni1QozQOUtwOCH7sU8TC+Br
	 gnaKxUkHOajKOo9sDgdVdf7jHC+ZXpvNL/Lt1eFtE7REtFa3oSTLOko6A4sMJP/lWf
	 TcyG+yJgoA706iaqrNTd7rKsieHLU17irvt2fS+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Li Li <boolli@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 58/83] idpf: set the payload size before calling the async handler
Date: Mon, 13 Apr 2026 18:00:26 +0200
Message-ID: <20260413155733.179370639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 8e2a2420e267a515f6db56a6e9570b5cacd92919 upstream.

Set the payload size before forwarding the reply to the async handler.
Without this, xn->reply_sz will be 0 and idpf_mac_filter_async_handler()
will never get past the size check.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Li Li <boolli@google.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -612,6 +612,10 @@ idpf_vc_xn_forward_reply(struct idpf_ada
 		err = -ENXIO;
 		goto out_unlock;
 	case IDPF_VC_XN_ASYNC:
+		/* Set reply_sz from the actual payload so that async_handler
+		 * can evaluate the response.
+		 */
+		xn->reply_sz = ctlq_msg->data_len;
 		err = idpf_vc_xn_forward_async(adapter, xn, ctlq_msg);
 		idpf_vc_xn_unlock(xn);
 		return err;


