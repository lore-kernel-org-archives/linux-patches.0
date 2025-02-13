Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C44C26B0BE;
	Thu, 13 Feb 2025 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458427; cv=none; b=bzTlDe5BWy/HpbUssMUzdaBOnxRgVh5gsRUb1DAg92GIK8ZyM+WU6rZppTDdnDZ6s+9H30FsRgA30yMUVSfFKgrghagby/eZIuORdDp8Ejs83BFPo0o44SLxxrImnrtrl004ZmxEvHgJg/Lbt/mfQSs2Dn+cUZKqLV7TDnCCYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458427; c=relaxed/simple;
	bh=FhCkDh6fS+9Qk3q+gghzleFdIsXdAUF/l9OKvkSRYp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLt4vt4UOEydqrkjIq+UiO8/NuUrOhfSmX/qhBrt+MMvsu9kyn3TvUfGlVmX8DwCE46IkB6GVdIZTa6FDSh7cLKi7UkYdALPq326ExitdDu1OKclf2KgIlldD0fFzMUJE/U1gR8MTCGcSBhwrbY5OcHkX8X5EPoS2socltRkEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdajlcLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdajlcLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61835C4CED1;
	Thu, 13 Feb 2025 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458426;
	bh=FhCkDh6fS+9Qk3q+gghzleFdIsXdAUF/l9OKvkSRYp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdajlcLFClscEbMUSkpL73hZXNWUHqKWqaUwu0pEMc5eZc0lKWf0V7aUa3hQr50Er
	 WZaxXRYXzB/+c3xtHIRBkpnnFWPn6aZAytD1c5x6/1wdxGN3RIeF5ip/31g11pJyFr
	 YQsC9CeCf3xXaHE2lvnvJkVACqdQBYytnfD0PLzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 369/422] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Thu, 13 Feb 2025 15:28:38 +0100
Message-ID: <20250213142450.788025654@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


