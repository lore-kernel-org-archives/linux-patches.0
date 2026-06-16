Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E24657F8;
	Tue, 16 Jun 2026 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626140; cv=none; b=oY6drATZekqvHxYesPmO4YHwDo1Z+9bSMsRawuz81pNSlcX7a3b+73CD18jzoZw0WNSyibH76XiGwWkci0ANsccNDOmvItt3a68U2a/rh4PLG5XerSBMTns/rCYywPq1J9oBtyofluKK5weGeRDI9TvlJToYBjKIgTaGmDWDoMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626140; c=relaxed/simple;
	bh=hbozn7N4FVFhx8r+uI/0obFGPfAA9smJMVsoA1GTttw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meY4r5tVDbttQMdrh5RmO81v20nV5gQd661bEc7MHKwUyhdIyUbonYlLdUxGE1XmsuyWpSMNcXxXy2i7ijTcWQ9H3X2q4/0sJ7I/SYmbLEFxGN2Auja9qCgeGWlQ2mx8ICrf1vw+539QF5uwa/TxNWDNvtxrNythPKng+BkEuV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB38fBnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB38fBnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB6A1F000E9;
	Tue, 16 Jun 2026 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626139;
	bh=594WuRq0fWd8LilZfmpmVnikpNykI2WjfAwil6UgsWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vB38fBnC3y3JsZHZh9d8BduajRGaQj5z3T7SF+9X/a3hwOeJJBN/Wx5m7wB/BOt54
	 DbL3uYDSp4Egbgbcw0UX08InVr55bEULA1bfxucZ8RCRLp0qFsqTt/waA4mmQhyu5P
	 nndFpIDwDpoHmXNk3WNWwilC1Fzbf5sQYYjXuPQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 271/325] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:31:07 +0530
Message-ID: <20260616145112.191082721@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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


