Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D041ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DABC433C7;
	Tue, 25 Jul 2023 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285606;
	bh=npFpegyrrwuj/MaFWb++Y4O9yLqjcLeLYDoUmAW2YqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBZ8AlKUV2/vT+6iYvvLZ/B9+dWiBNR/cmEFLkL3MrsJALUDXN5wzGUtFqhVE6VI2
	 zFxC56lSH1+oDfJvnOnBWbLOMog8PnRt8V6yDCpcE0QHyUdiNYlwfY8se1rXxgip4p
	 iR7vZkvA1nOK8ZAHs64Nxrf8ubr8hEiMBDpxY9Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 266/313] xtensa: ISS: fix call to split_if_spec
Date: Tue, 25 Jul 2023 12:46:59 +0200
Message-ID: <20230725104532.551329755@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Filippov <jcmvbkbc@gmail.com>

commit bc8d5916541fa19ca5bc598eb51a5f78eb891a36 upstream.

split_if_spec expects a NULL-pointer as an end marker for the argument
list, but tuntap_probe never supplied that terminating NULL. As a result
incorrectly formatted interface specification string may cause a crash
because of the random memory access. Fix that by adding NULL terminator
to the split_if_spec argument list.

Cc: stable@vger.kernel.org
Fixes: 7282bee78798 ("[PATCH] xtensa: Architecture support for Tensilica Xtensa Part 8")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/platforms/iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -231,7 +231,7 @@ static int tuntap_probe(struct iss_net_p
 
 	init += sizeof(TRANSPORT_TUNTAP_NAME) - 1;
 	if (*init == ',') {
-		rem = split_if_spec(init + 1, &mac_str, &dev_name);
+		rem = split_if_spec(init + 1, &mac_str, &dev_name, NULL);
 		if (rem != NULL) {
 			pr_err("%s: extra garbage on specification : '%s'\n",
 			       dev->name, rem);


