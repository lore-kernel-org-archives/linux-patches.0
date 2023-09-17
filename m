Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D766FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CAAC433C7;
	Sun, 17 Sep 2023 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982956;
	bh=TLGVOp9sbTw3pLKGUBOgg9Ean2G0gK6rj1rjyN6UayM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkC77W99Nm4kCPH/qqTVFL1LJehNweSTWYcgDUcoKvijJHS50VoBD/n87nv8c18NH
	 xBEEV+4i+iH9vShcYlz1yZtdkxeq+YqRNr5C0jrTMWfHDjtGWhD9Zfdjlo82X+soDO
	 BHfJVmEBlgtvUL1AR2VktbQDdgACATi5b/TilYTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <quic_clew@quicinc.com>,
	Praveenkumar I <quic_ipkumar@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 401/511] soc: qcom: qmi_encdec: Restrict string length in decode
Date: Sun, 17 Sep 2023 21:13:48 +0200
Message-ID: <20230917191123.473665756@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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


