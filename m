Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E6F70805;
	Thu, 13 Feb 2025 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460882; cv=none; b=FpSGktxqnHrF1/7E+JdgG1AxkNb0KmMLqvgfDdFaowCL07CEso58hqZZIMtyXjjZuAo+kG7TVh/yOui27AXxGc2oioBA8K2KEWVNwKT+Niblyg4HjcdmabdUrtqCqdxi16qss+iKuUn+bwzOW3nNELecefdWGNlYYNroSCwz60k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460882; c=relaxed/simple;
	bh=qR51M7UJs5MOPLtC95eaLVyisWQHhM/aj+j336u0ck0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGrlaNdpE0J4/LfobvDVETHJG6Dv8lscOdlchd0Unv/BI1+Lxa1pEAUMt+SyZpopIQOJtsMv0vHN5K+O36NGqBI/My5ooZS6H0BSzBujaPEWbiOp9GxL2dJmjGp1uB1w2MsgSJ4udjAmxMIamY7Zclc/i5xWMYXPtaSDbM+aG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHe7lkzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHe7lkzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D424C4CED1;
	Thu, 13 Feb 2025 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460882;
	bh=qR51M7UJs5MOPLtC95eaLVyisWQHhM/aj+j336u0ck0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHe7lkzHqsUjoIwL2oauodgUdiZHCTf8z79OrSxq3PimX2sqqz0m8CSIlrEjw82Mj
	 A+2v8ZxyZaSKN/ROi/ts4HWTOTx1lIBJF7rey4hcsFZu79IMcHwgT3AwlN+pCvtnIw
	 I92ego2iuuA6l9V11dOidVNmsNo7VRPMA3rSnRao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 207/273] media: ccs: Fix CCS static data parsing for large block sizes
Date: Thu, 13 Feb 2025 15:29:39 +0100
Message-ID: <20250213142415.502744644@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 82b696750f0b60e7513082a10ad42786854f59f8 upstream.

The length field of the CCS static data blocks was mishandled, leading to
wrong interpretation of the length header for blocks that are 16 kiB in
size. Such large blocks are very, very rare and so this wasn't found
earlier.

As the length is used as part of input validation, the issue has no
security implications.

Fixes: a6b396f410b1 ("media: ccs: Add CCS static data parser library")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ccs/ccs-data.c
+++ b/drivers/media/i2c/ccs/ccs-data.c
@@ -98,7 +98,7 @@ ccs_data_parse_length_specifier(const st
 		plen = ((size_t)
 			(__len3->length[0] &
 			 ((1 << CCS_DATA_LENGTH_SPECIFIER_SIZE_SHIFT) - 1))
-			<< 16) + (__len3->length[0] << 8) + __len3->length[1];
+			<< 16) + (__len3->length[1] << 8) + __len3->length[2];
 		break;
 	}
 	default:


