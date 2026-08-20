Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8831B36212F;
	Thu, 20 Aug 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238483; cv=none; b=t43IMcg2UQqpTibK+JjLEYHM2ytvRnf6NL7bpPW1aR9+0Cm0O3dT/+nsbs1lHc64oOG7yWMCV01Kl5s7FYHpPFHYSCPL81g/WKkV7ztQIiztKj20w20h7lM94der8akzmDvj8UqTosrx/0vIUq37uFN2uACuuH1ynJD670qs2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238483; c=relaxed/simple;
	bh=jsdQJmuzYU/Ut6IoLW6Bt5DjjwYYzfqsQMduy13mPPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J16m/gimxHmysGNHrgHOeuvxvgXkzhnX6FaZNPPMdGIEgT+bbqXRYxhzKW4pZihDCEixFhmOsDSUWpZGi+eYWZqwLVnkr69pJIaD6WaOKsDt26gw2MzwV1/Hct79RmiZCvR0uB0FEVvnFW5UMj5HFuVW0EZLPNd8RM5YD6a3k8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGbll+wu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGbll+wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15401F000E9;
	Thu, 20 Aug 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238482;
	bh=/qjuqMUk+GyaTv/xWbHqORUYRAu7vX1aY5FV23ZU4cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGbll+wukxRA3rtTVmjUMhX/GB1qClY1rq5kX0mQbgFjIMfi/S/9k9wiAI9hVTWEQ
	 0OdkytwQ5Z1Ko839ohy77fNJnTYZyv3ldcUJHCk6ElDsFz4m7Jkhsxqc4FpJ2z5qds
	 A4n48N928nOE0w8Xl7rqcOZLkKnC1xMOMf2ltuQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 163/228] optee: ffa: Add NULL check in optee_ffa_lend_protmem
Date: Thu, 20 Aug 2026 16:55:05 +0200
Message-ID: <20260820145249.631956307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 650c88738ae8976f46ba71b24dd8aa311adc6fde ]

Sashiko (locally) reports a possible null dereference under memory
pressure due to the lack of validation of the allocated pointer.

Fix that by adding the missing check.

Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Reviewed-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Jens Wiklander <jenswi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index b4372fa268d03..633715b98625c 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
 	int rc;
 
 	mem_attr = kzalloc_objs(*mem_attr, ma_count);
+	if (!mem_attr)
+		return -ENOMEM;
+
 	for (n = 0; n < ma_count; n++) {
 		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
 		mem_attr[n].attrs = mem_attrs[n] >> 16;
-- 
2.53.0



