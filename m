Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387944CF37;
	Tue, 16 Jun 2026 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627658; cv=none; b=J1hC18h7SLRVYc/WkJGC4QjfCb1eidcD1UYL+ajup84oXu3cZzv+citzIBtkRfxjH/gM9kXJiHqL8jLf0oLpgOyDpvYWqRLF2bDelDUhg/0Dm+sohQQXGdHklzh5RZQVcN08ibVY7YE3trmnmR1tWu+nGgmv9XuGD1NUIyoMT7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627658; c=relaxed/simple;
	bh=FtEOLCCLwbDDvA8O8magH9QMQ6kSR5rdRMv/0A9JgZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqmLNeWWsah8yezQAsNmtTp9IYuezl9R2LCwbt8YAnKXnqSE94WVx+ejI8jaRRskWsCNhvWm43RpI/3tH3aMcHM29F/m0Zq3fVtQik8i3RmY4UYEXLy+Kxy0M8Jt0DXPIOK7PFeQ3Kl4SaJedMgn0bIx+rW6e9d/4dBP079Sfsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YalFoovj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YalFoovj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7BD1F000E9;
	Tue, 16 Jun 2026 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627656;
	bh=FcqNvtJ6+hfFBwQaRi5otTC1I7JQLXYTaoO3xQfpCNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YalFoovj2U5y0Jb+RjtAV8zt/8A5HHtu6KC6t+osbejSg2dwKukW67rvtcCBsydN7
	 xlgDadkfpVuJfXpxKxFh5VGI0kkyVf5tDIe/HMVyZ1uinPuVU2fo9MMXKiDa70rVR9
	 C+qfxiHJf/1dj7C10y83FKiTgdkgB57Ax8RP5qk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 204/261] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:30:42 +0530
Message-ID: <20260616145054.502364604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 322e93448d908434ae5545660fcbe8f5a7a8e141 upstream.

tb_xdp_properties_request() derives the per-packet copy length from
the response header without checking that it fits in the previously
allocated data buffer.  A malicious peer can set its length field
larger than the declared data_length, causing memcpy to write past
the kcalloc allocation.

Clamp the per-packet copy length so that the cumulative offset
never exceeds data_len.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -393,6 +393,8 @@ static int tb_xdp_properties_request(str
 			}
 		}
 
+		if (req.offset + len > data_len)
+			len = data_len - req.offset;
 		memcpy(data + req.offset, res->data, len * 4);
 		req.offset += len;
 	} while (!data_len || req.offset < data_len);


