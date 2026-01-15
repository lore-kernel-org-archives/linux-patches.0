Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057E63BF305;
	Thu, 15 Jan 2026 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496785; cv=none; b=SXmxtjNZ3pWHiQIpt0toSUZo6keEu8CquToTmgA3OhoYnKcpHdFAMQHKRQ44TxzD2Odbv08WyL/eM8hRpsp4bxVH2eSppIYh0iqtJxrF8SwBaIWUzYX+YAfNUkK02vhQlcsIm9Aa82TC5kg/JluGYfQKU/RJJehkllNAw3nY6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496785; c=relaxed/simple;
	bh=UFyyhHa9yDz57fWxPnbZOaI6qzw94ESebTZk4Tt2ejE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1/86e8kXcXMkXQuvkX2MeFhWNEeSUHr4VpfG9CoEFesWqIzLMeXLyPiNGgkcoVhH1nUWZv00bPbZ1tezArT36wbq7C6h00fnMK2nRD25N1iZ+kxsHYnWsIRHdoa7aQdhF6mDLFCulfJ8aVCGnlT24HcHfhnZ6wiBop+CAmuEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRwfGq/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRwfGq/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FDFC116D0;
	Thu, 15 Jan 2026 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496784;
	bh=UFyyhHa9yDz57fWxPnbZOaI6qzw94ESebTZk4Tt2ejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRwfGq/4Do6dhEffRyf6jiwnzztyVOl7/9PvvXW8h7sY1nn94kgo0R5Z41CxT+EuE
	 FizZOxCT1fE48zx19xQ0+qayK5V8aEI75LqjWUL68JdqAHW638ifx3z0kVLGGbHfJT
	 eyEhG0DBmTnwQp54209Soi5oVNuGNvuPiQvJhMc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 15/88] libceph: prevent potential out-of-bounds reads in handle_auth_done()
Date: Thu, 15 Jan 2026 17:47:58 +0100
Message-ID: <20260115164146.870370797@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: ziming zhang <ezrakiez@gmail.com>

commit 818156caffbf55cb4d368f9c3cac64e458fb49c9 upstream.

Perform an explicit bounds check on payload_len to avoid a possible
out-of-bounds access in the callout.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: ziming zhang <ezrakiez@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2409,7 +2409,9 @@ static int process_auth_done(struct ceph
 
 	ceph_decode_64_safe(&p, end, global_id, bad);
 	ceph_decode_32_safe(&p, end, con->v2.con_mode, bad);
+
 	ceph_decode_32_safe(&p, end, payload_len, bad);
+	ceph_decode_need(&p, end, payload_len, bad);
 
 	dout("%s con %p global_id %llu con_mode %d payload_len %d\n",
 	     __func__, con, global_id, con->v2.con_mode, payload_len);


