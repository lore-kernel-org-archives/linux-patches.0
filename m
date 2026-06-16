Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F4F449EAB;
	Tue, 16 Jun 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624366; cv=none; b=dBB9VKMLU6WL2KI6CejNDE2baUnEHFsp9RWtVoTAna/LSv2SAutLsceRcgk/hlU9eStH/eDFpkv/374Zx3TQg0kefCWV4Bln28980DoAk4UNMCziXbDI5/gfr/oqXFcZ9IzPyRl2pe8c5pjNhWtKxQXYRirqPN0U/cqjvKBL92Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624366; c=relaxed/simple;
	bh=cpwM6MAZ3WWOekl/nJvDPbZ4tWgsMBv3zbkSLKzX4Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxRqmeCpdNGYWW+DaNl+mK5SeXGkkAR9hit/JBiObG0nXI6Vj5Bz28XZx7wyfI+P32oTyvPWGbmqKkcZL572ay0RZHwMVR0sK3KWV5LVihymNhYfNerIIgl2crIgxZ5wTJJ8/Id3IeMJkuuHoxHss9AoHmGw6cbNvXbiMwvn0Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=us81mIXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="us81mIXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC151F00A3A;
	Tue, 16 Jun 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624365;
	bh=ISihV/U/GtU278nsJgPeCipUBFKz/E+4pHStPaAhKzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=us81mIXRqsCBSzJZMObvHaVgIx1L/0pLJN+inqrGzGuGxaYxd8/RBJDoEunKC/yeg
	 0G9NODnE1PULTlcQtWrhcO0tOaYYRspWxJgbQFbuQRUNn4+9fvAYoZz6KF/KtkIvr6
	 g7xHQHXFR8jgvxex69CW2vZTROnshqcmjf5eKsD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.0 322/378] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145127.189961627@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


