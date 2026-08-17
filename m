Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF1D3C3C08;
	Mon, 17 Aug 2026 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975094; cv=none; b=pCybsg9N0UM/Usgj5KipryooJbF7VKd0iFZMegc1Wny4ukZYbqvmF6DMRTlIdyMs+W8CPWNWM/5ytVT3RuzSPaRm+VT0IVVbMsjZf65E2ICcRw/FhJqsYNCxlZVNdQwcJwB7Ga3cUkDULDBRstdcyeh42/iTSNkfwQy1Pk25K/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975094; c=relaxed/simple;
	bh=gjE2RX3/tREabRTF0Hrr0qbx+mB0U+zOvst8OLoXJR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP5E3UIdA45ESsW0B7/Jlh4uhV8Ey4qP4DHZCfo8lIYVbrBIKfs+dP+D3QS5Q/WqiZi3mq6notq5JWJz6gWnItyBNLKXGqY9c/18FFBFqyIyFXYFE5A+2gsd2Yd8A7B+Bq59Ux0j9stMvVa100L+kInyu/cKGj6lZE62nNXoMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0i8Z3/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0i8Z3/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163071F000E9;
	Mon, 17 Aug 2026 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975093;
	bh=QoZTF7BL53hxpU5EDSTX38DATkpKDtBaRg/lOaMGV8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0i8Z3/1KrnAjK7jKt5wGZ4l3eByozI3t1LGlLsz6aXUN1ewq9d59djGvJ1R8s1jI
	 wsw7D5fMen4T3iQTESkYXqrczqkF9vvIzh7Q+RYUlSAwtlvEkYIefSC/9Oi4jw/OcA
	 ygytmsnwdXmbE0CnTUQHUryVKvjPODwNtu/YpsHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.18 120/250] usb: gadget: f_ncm: Use unsigned int for ndp_index
Date: Mon, 17 Aug 2026 15:31:21 +0200
Message-ID: <20260817132541.496762458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 6b1c8a9403a26cb0fed7a648916c74dc236da591 upstream.

The variable ndp_index is declared as a signed integer, but it stores
the return value of get_ncm(), which is unsigned.

A malicious host can supply a large offset that overflows the signed
ndp_index, making it negative. Because ndp_index is compared against
unsigned bounds, this negative value bypasses sanity checks and leads
to an out-of-bounds read when calculating the address of the NDP
block (ntb_ptr + ndp_index).

Fix this by changing ndp_index to unsigned int to ensure consistent
unsigned comparisons throughout the function.

Fixes: 370af734dfaf ("usb: gadget: NCM: RX function support multiple NDPs")
Cc: stable <stable@kernel.org>
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260720165654.2224591-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1171,7 +1171,7 @@ static int ncm_unwrap_ntb(struct gether
 	unsigned char	*ntb_ptr = skb->data;
 	__le16		*tmp;
 	unsigned	index, index2;
-	int		ndp_index;
+	unsigned int	ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
 	unsigned	block_len;


