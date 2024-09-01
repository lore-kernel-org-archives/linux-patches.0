Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0128444C97;
	Sun,  1 Sep 2024 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207682; cv=none; b=FScHyZjPUo7pXywn4kHXKabP2tXRFSLXAoVtUtxX4YatBiH9hlYy0zCp7ke/CmNyMoremx/ML9Q/UkZHB+UF/1cFp32i0KGPqG7kV7hB0J+L7wl0wfcWgoASjxmzw59cD7gH7STpyaKw5P7FZvlSTd51Cb/9vksPaf6pIyuYGRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207682; c=relaxed/simple;
	bh=iVgUjstn6FH15bIjIFzIlVdXKq96jCKUWw//9JDbpA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGqZdYyueKkhwY/ANnTVkbwb3jGwMG3coFFfUwhSJw/8h70sEh+j0GitebmPG1I8xEiR2xkLe1H6UikcR7gNEvZcBlqXoEnkik1MoyUF/2rTN1mZF1fIpe5h3bpeDy/Sqw3XpAFB+fvRHWQAonFvmzOM7Qj8J/ax5Qyv/019cyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAjCSui3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAjCSui3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16058C4CEC3;
	Sun,  1 Sep 2024 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207681;
	bh=iVgUjstn6FH15bIjIFzIlVdXKq96jCKUWw//9JDbpA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAjCSui3uD403Bc2T6untUn1FK8hoJWHcCishFM6B2yvTD73IHbJBQiP0984I0OiM
	 6M5x7ZvYxF01z3e/R4JD2bwaTMqFo+xOGImZASUXXgcmAjO/wMnJoN8g/eCjXyNfAs
	 RX8siTpF1pLA8nty6NLA6up6t8C7o5++GrBnYlTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/98] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Sun,  1 Sep 2024 18:16:15 +0200
Message-ID: <20240901160805.398378850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 2f82a6f0992e4..b1ecf008fa507 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1149,8 +1149,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



