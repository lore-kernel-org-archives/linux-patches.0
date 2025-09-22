Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9332F49E3;
	Mon, 22 Sep 2025 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570143; cv=none; b=TortF3J2bSr//aFoO/j3D0RK9OSsoWrjYJ2aWidh7kqwtaCP8KMHKoTJfv/yq+qJCgnsnIbpYEd/eh4cl7L3QUjCGx9DWjzzkMeEKCB/BJKL5IPbXVZgMefhgZVJo2IqlVvM4CiAvMdXAXa9FIQpKR45kFe5NQkVNIcQ4nybqGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570143; c=relaxed/simple;
	bh=pc7moO8cjUuFBaVU71Ge9NxZS47LNpzQJukgmQWSqFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZ2ovgTiBxEfWAhY9NP9O3jNMXqoLZqgdqStL87sDvj4qWCQCJ00VkWiQf4upPkTUwAOvUfIEqo9azlbzAVfNusgvcg7qINn95vebxBxBkRs4o2YHApy7V5aoASc3VODTkS4lSG69z+8iMixUSvxmNA1P7BhQbc0p+TlnJZ2gjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E78vVTdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E78vVTdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA758C4CEF0;
	Mon, 22 Sep 2025 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570143;
	bh=pc7moO8cjUuFBaVU71Ge9NxZS47LNpzQJukgmQWSqFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E78vVTdQT3JT+wPiVkFtxJGzQY4RY7q6qG6DqQBE9lUdkyDZwECvgp8igdIIAQgrn
	 K0LkklE5Q+gLL1t4o/zhjHJw/V8AqMTloBbJUVsRNRjKiyfIlN1pMPpq3fVWFP7+g3
	 2z8Xgbf6hG/PzERNL4YON9rji274LHs7sb+NcvC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 035/149] doc/netlink: Fix typos in operation attributes
Date: Mon, 22 Sep 2025 21:28:55 +0200
Message-ID: <20250922192413.751489529@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remy D. Farley <one-d-wide@protonmail.com>

[ Upstream commit 109f8b51543d106aee50dfe911f439e43fb30c7a ]

I'm trying to generate Rust bindings for netlink using the yaml spec.

It looks like there's a typo in conntrack spec: attribute set conntrack-attrs
defines attributes "counters-{orig,reply}" (plural), while get operation
references "counter-{orig,reply}" (singular). The latter should be fixed, as it
denotes multiple counters (packet and byte). The corresonding C define is
CTA_COUNTERS_ORIG.

Also, dump request references "nfgen-family" attribute, which neither exists in
conntrack-attrs attrset nor ctattr_type enum. There's member of nfgenmsg struct
with the same name, which is where family value is actually taken from.

> static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
>                struct sk_buff *skb,
>                const struct nlmsghdr *nlh,
>                const struct nlattr * const cda[],
>                struct netlink_ext_ack *extack)
> {
>   int err;
>   struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>   u_int8_t u3 = nfmsg->nfgen_family;
                         ^^^^^^^^^^^^

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Link: https://patch.msgid.link/20250913140515.1132886-1-one-d-wide@protonmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 840dc4504216b..1865ddf01fb0f 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -575,8 +575,8 @@ operations:
             - nat-dst
             - timeout
             - mark
-            - counter-orig
-            - counter-reply
+            - counters-orig
+            - counters-reply
             - use
             - id
             - nat-dst
@@ -591,7 +591,6 @@ operations:
         request:
           value: 0x101
           attributes:
-            - nfgen-family
             - mark
             - filter
             - status
@@ -608,8 +607,8 @@ operations:
             - nat-dst
             - timeout
             - mark
-            - counter-orig
-            - counter-reply
+            - counters-orig
+            - counters-reply
             - use
             - id
             - nat-dst
-- 
2.51.0



