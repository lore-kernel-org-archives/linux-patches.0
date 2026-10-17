Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E432D7D3A;
	Sat, 17 Oct 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256734; cv=none; b=hfftOx/XNo56tfoIeLx5/90+YtSOAI+Ip9mIK0LGe1zpdPGtFCeoN/2DbDRvuK97M6puhfG1fObZEoS5dc5YnUwHMdiH/7OXaoedZK554DhlH5hf3AiWBbFeNMnYlzC4ytbHOpICANtJY0mbk6xjTGRUjtSHmR7UbQGl3BB3NwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256734; c=relaxed/simple;
	bh=ufbLdeNgtAPyTJOe13iqaROvg5ObIS9codWX/TXp0E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnhrj+/y5GIav39KJN2MvkCUBD8PyRaRi8UrfL/gSvwVM7aa3IRmfDo38zN0J8h6tNtKcrcKLmxRni3iliujhrBRwd+AfaTvcpk5ISsXILVzu3JWGZP/gBd/Tl5mZjX1PqzGooCPG6tiZLkUey2Ss3hq9Bw8OrNiuqU9hDWXz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBG7IXZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBG7IXZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71571F000C4;
	Sat, 17 Oct 2026 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256733;
	bh=YH9W6P11TK2t7y5D4VChTJH36l49RDhkcqZRJ2+t8Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBG7IXZOQdPTdpklGLH1AyGRZOo6kOHHNpcQnyaompeoCace62I6EfJxqRBenvkGz
	 lNrbOZSoCI5Tr8npLP/a6L/GeJqnJrwOUSPI1v/swywtk3WzshhyksZX5CvkhYx7Hi
	 hZCG/nP5zhzMNuWCzZ4Q4ymXVYchLiOcBtIK8gWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 0333/1674] thunderbolt: Reject oversized XDomain properties responses
Date: Sat, 17 Oct 2026 17:43:25 +0200
Message-ID: <20261017160439.675462017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 80756e263846ab694984e749e8c626897331438f upstream.

tb_xdp_properties_request() allocates room for 45 data dwords in its
252-byte response buffer.  The XDomain length field is six bits wide,
however, and a malicious peer can set it to 63.  After the fixed response
fields are subtracted, the driver treats this as 48 data dwords.

Commit 322e93448d90 ("thunderbolt: Clamp XDomain response data copy to
allocation size") only bounds the copy against data_len.  If data_len is
at least 48, memcpy() reads 192 bytes from the 180-byte res->data array,
causing a 12-byte heap out-of-bounds read.  Commit 4db2bd2ed478
("thunderbolt: Limit XDomain response copy to actual frame size") limits
the earlier copy but does not constrain this header-derived length.

Reject response data lengths that exceed the allocated source buffer
before copying them into the assembled property block.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -377,6 +377,10 @@ static int tb_xdp_properties_request(str
 
 		len += sizeof(res->hdr.xd_hdr) / 4;
 		len -= sizeof(*res) / 4;
+		if (len > TB_XDP_PROPERTIES_MAX_DATA_LENGTH) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		if (res->offset != req.offset) {
 			ret = -EINVAL;


