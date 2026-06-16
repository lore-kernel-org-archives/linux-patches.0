Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66B44CAC6;
	Tue, 16 Jun 2026 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623773; cv=none; b=o8InUHGboWACiPka8Dn/B8zi7ckx5QWjB0Cm+nmVC9I0HEVcKkCMriCn2emcF34DjUhhUr0uoE9E9v4tfkAQjUtEPKSGWxkK/6flfvUrbmuRlaYSo1HHURC3FkY1UNJPh9ImRjwy4wT5G1W5uquMb0DypC6Fby5OPg/XM1wmDy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623773; c=relaxed/simple;
	bh=BJfHogd47v6y3K1kSS6bdmkErb5hQ8dJB/0olpqpO7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvWFKJsck7TZvhDfIS8+RQMqAXdFnXeH4t0gnYMhsmFz0y+TUBfFBs5CYcB/9uk1buOzNOnTuhw2bA3LqHJjdDqpmjXp6e6Y9l6zm5gda3S9Xhbv/xg/LoZ0HK4FdJOtJdN3jgvN8TAacEuhBmrnQzqANesJvLCP1xDxKVO8BcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdrEYk6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdrEYk6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0871F00A3A;
	Tue, 16 Jun 2026 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623770;
	bh=8ajWILx+I9kIWSkaHuC0vqYaG9IbZ1tbQmJS5N7H7CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdrEYk6jk5xbDhXHsAymteDa69P/FWm72SI4xipLwAWfA7/PYrMtYH8TUJ78Grnyx
	 ZqoUgAXZy4kl6n3qvw4VeT1tO09jOjUsOz/VlCQ8nynl8vzarJ+fVToSQwGX99uxfN
	 u3t6TDLAn4p7GaygfJxkfLvGnKCTSUMqPBvzX6bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takao Sato <takaosato1997@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.0 205/378] xfrm: iptfs: preserve shared-frag marker in iptfs_consume_frags()
Date: Tue, 16 Jun 2026 20:27:16 +0530
Message-ID: <20260616145121.170580464@linuxfoundation.org>
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

From: Takao Sato <takaosato1997@gmail.com>

commit e9096a5a170e7ecd6467bc2e08668ec39897cda7 upstream.

iptfs_consume_frags() transfers paged fragments from one socket buffer
to another but fails to propagate the SKBFL_SHARED_FRAG flag. This is
the same class of bug that was fixed in skb_try_coalesce() for
CVE-2026-46300: when fragments backed by read-only page-cache pages are
merged, the marker indicating their shared nature must be preserved so
that ESP can decide correctly whether in-place encryption is safe.

Apply the same two-line fix used in skb_try_coalesce() to
iptfs_consume_frags().

Fixes: b96ba312e21c ("xfrm: iptfs: share page fragments of inner packets")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Takao Sato <takaosato1997@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2170,6 +2170,8 @@ static void iptfs_consume_frags(struct s
 	memcpy(&toi->frags[toi->nr_frags], fromi->frags,
 	       sizeof(fromi->frags[0]) * fromi->nr_frags);
 	toi->nr_frags += fromi->nr_frags;
+	if (fromi->nr_frags)
+		toi->flags |= fromi->flags & SKBFL_SHARED_FRAG;
 	fromi->nr_frags = 0;
 	from->data_len = 0;
 	from->len = 0;


