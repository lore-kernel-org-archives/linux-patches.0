Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45FC15AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DD0C433C8;
	Wed, 20 Sep 2023 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212290;
	bh=F3DhPkRVJfuvIWYF1efPbXERfbWn5ZTMXpALiE3UtdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7XhnNxjtljAv254O5lUKBV0W9a9PmDgjQtwCmm8eYrjx6wt7YEB1oRXXUyADbP6+
	 XvEnICD0VPyPr4mmD4Jz3BDNQA6kK5Ghkb/XZ/bbHO/42wiTt/CH5ns8tiwNlr77Sq
	 JmnlcpucAsD46zdbi8pl0sG7ERU7b2osN2p4tsRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Praveenkumar I <quic_ipkumar@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 4.19 204/273] soc: qcom: qmi_encdec: Restrict string length in decode
Date: Wed, 20 Sep 2023 13:30:44 +0200
Message-ID: <20230920112852.795062946@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lew <quic_clew@quicinc.com>

commit 8d207400fd6b79c92aeb2f33bb79f62dff904ea2 upstream.

The QMI TLV value for strings in a lot of qmi element info structures
account for null terminated strings with MAX_LEN + 1. If a string is
actually MAX_LEN + 1 length, this will cause an out of bounds access
when the NULL character is appended in decoding.

Fixes: 9b8a11e82615 ("soc: qcom: Introduce QMI encoder/decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Praveenkumar I <quic_ipkumar@quicinc.com>
Link: https://lore.kernel.org/r/20230801064712.3590128-1-quic_ipkumar@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qmi_encdec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/qmi_encdec.c
+++ b/drivers/soc/qcom/qmi_encdec.c
@@ -534,8 +534,8 @@ static int qmi_decode_string_elem(struct
 		decoded_bytes += rc;
 	}
 
-	if (string_len > temp_ei->elem_len) {
-		pr_err("%s: String len %d > Max Len %d\n",
+	if (string_len >= temp_ei->elem_len) {
+		pr_err("%s: String len %d >= Max Len %d\n",
 		       __func__, string_len, temp_ei->elem_len);
 		return -ETOOSMALL;
 	} else if (string_len > tlv_len) {


