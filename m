Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926DA15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE3AC433C8;
	Wed, 20 Sep 2023 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213471;
	bh=IyRwz7j+OHzakOyTw7UiD2AYV+nxif7QJM8/Nhgz7Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxrsespnatZL2QuXtMaHhNqQwTr5psb1u6de6GLPHF2AnLjPcPaXx1AIMX2RIDof7
	 e74x57mfiA1JEJHvHuOfiFOSzZuA5MQEebWkLLZBBi08D6O48YokLZTaO9zLaoPo7h
	 2O/w8ZGfpuLHW4QZcWkzb+kRB1pItJWNgvXMsSNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Praveenkumar I <quic_ipkumar@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 250/367] soc: qcom: qmi_encdec: Restrict string length in decode
Date: Wed, 20 Sep 2023 13:30:27 +0200
Message-ID: <20230920112905.029172659@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


