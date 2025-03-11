Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686725D8F9;
	Tue, 11 Mar 2025 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705787; cv=none; b=MXL1bYOPhQ2JTG/iQfl5y/d7r29bZfcKQ003Mh8J8gDmoqAXsf5jsL/oxYXtqz9vbCYDFdrJeYiWOl/v904SyUeEQJr/R4wMakf8GJvjQpI1oaLSYm2QtFwxh64wr8C9EED75AtciaM+VvVFG4R9u0jLo8MkOMRpJNuxA0+DpiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705787; c=relaxed/simple;
	bh=77ssY5a1k4+2I1DTznX3CYAdSOl0Ub5C5PZaatqJe7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNrfaVwcTb418/plouf3oC87xUU/V5TznoqQmfWxXO1IEsH4kUBnM4uy4IKdNgVgF46UmayJXj/y8UqEQ/EoHgoyctCwiMrM5Fkl1uBX9yNvfQAy0YW6R9cnrKgoV1y3v1mUXi/ycRQSokdfQgdX2xoti+E64l+/EuLGuqMfHOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCudhDai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCudhDai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBF0C4CEE9;
	Tue, 11 Mar 2025 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705787;
	bh=77ssY5a1k4+2I1DTznX3CYAdSOl0Ub5C5PZaatqJe7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCudhDaiXrsKWlMZojayQtPU5wGnBCbABetnnJOaiDVJXPjmqZT/8ydP7rbnycaG7
	 kCbC6wAdUiPwwlPl3zDze3CpP/OsE4r1M30HPM2dhjOOK3MsvtZP87Dr1bRLDj4B79
	 jHqgjQlpJ1vhGuUJSEiZfy0jha3O+7ETUt6+xqkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 155/328] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Tue, 11 Mar 2025 15:58:45 +0100
Message-ID: <20250311145721.068626391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 110b43ef05342d5a11284cc8b21582b698b4ef1c upstream.

The "pipe" variable is a u8 which comes from the network.  If it's more
than 127, then it results in memory corruption in the caller,
nci_hci_connect_gate().

Cc: stable@vger.kernel.org
Fixes: a1b0b9415817 ("NFC: nci: Create pipe on specific gate in nci_hci_connect_gate")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/bcf5453b-7204-4297-9c20-4d8c7dacf586@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/hci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -548,6 +548,8 @@ static u8 nci_hci_create_pipe(struct nci
 
 	pr_debug("pipe created=%d\n", pipe);
 
+	if (pipe >= NCI_HCI_MAX_PIPES)
+		pipe = NCI_HCI_INVALID_PIPE;
 	return pipe;
 }
 


