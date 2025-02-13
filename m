Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DDD35961;
	Thu, 13 Feb 2025 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459932; cv=none; b=ErVystEmxDkLAfcGxkLkTkzINyeNo3PNqsbocUo5BkXDxj7HjpXEMs2jExWtbS41TuQx0BbMqcMAvSxD5z5+lqdNqMomxaQCHEMSDACu8lAoXU7aNLyOCsI/izVjB0hOA2pwssUALayzKyvIIVT6PQFjJS3Cpk0j4Ut/ZhaHUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459932; c=relaxed/simple;
	bh=WTXca+N5d4QxjyG9Auw8m1roSZ4KgU7PlIPwCHDVwXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+yVyC4DVCDivrEL3bmqH6V+D5Xln+Ul+I0BK+yXZ8OgKL7dlRCSjy9xPgZ/fKIQEiV+z/VzxK2l1glf1EKwQgevurvNfZI9exzGuRyztZk20LMyrIRoWs3V99vgs/0z7N9onct7DtpPvHlRWYKkiv34l+LT6A20NbWB2VGIWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYCHM8PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYCHM8PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD41CC4CED1;
	Thu, 13 Feb 2025 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459932;
	bh=WTXca+N5d4QxjyG9Auw8m1roSZ4KgU7PlIPwCHDVwXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYCHM8PH2cVJj6+RALdipMkwz/1sxOjwtVE0SG5TwILPJp57bMNCiWV5W1ZliMGKB
	 xSWKN6TOeYO+NqfLVPZDCRtdjZJ72+n68UbOBuSXAdw9MxUw5UrNgS+PhaXe92Y5/G
	 BQwvW3bQ0tCLBreXUk3DyVqOHvX3Mcw2FjJbo6oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 406/443] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Thu, 13 Feb 2025 15:29:31 +0100
Message-ID: <20250213142456.274469269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -542,6 +542,8 @@ static u8 nci_hci_create_pipe(struct nci
 
 	pr_debug("pipe created=%d\n", pipe);
 
+	if (pipe >= NCI_HCI_MAX_PIPES)
+		pipe = NCI_HCI_INVALID_PIPE;
 	return pipe;
 }
 


