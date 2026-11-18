Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042729;
	b=L9Qfs7S6g1IwDe1Gcv+hUQtCb6NngAFSSCGcg4wc3hxJeqT6FAGEGA7sW8SATYWimkKX
	 vHpViD/VedYxbFqM48FwjQurfqOEQl4zJcQ/t/+C5x1PLZ9dX63ejchJzoOYsjWhxCY4d
	 ZKe4xs96sj8Cv2C2h1zgpwm5JDzIa8e6JQVt4Il+XW8UHWG102hPLGtOlDqKStwbDwODz
	 jOMHmIIbr4kxCYFaa0VtWeVY4YMfSTwYdQbiiyEjEmpMbJqeeVN58J2gU5lfDjDH7b/W2
	 2kkrnZHaH4VGxMaAHnAYEI2G/PvDINrbp2ucC1sCpg7NQgSvBv/j+Fx+FxHc+xwlUwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fbk7iV1A5LF0N8W1B4j/3iH8CD6bp3+vKrifFEtIvY=;
	b=GbOIWhbKj7O6wjsnfsWYXYeCAMFEu3TSveq6bg4AGkZgFMbRYdeckS5jUzWctl9OF6+N
	 Q4J3LyJzwF5F1W6r4SUf4i3rY6Ch1E0k7EkR0Es9IijPaMkJJXjWXyQ0hRwIEasFaLSRB
	 rK1v3IKIoRvSfz3tMFPzUiOjwk2wTX4FgCSWvyH4/GccaVUfTohbpScUzMdlX8Zk+9O7L
	 u2Gh1/Plwqw5jEppuI+q1E9FHGc+vxC6p0bsNpL5nLKR1t2LSlU/s4ON9K/VpiU8Dy2v7
	 G+oDBDDvO1oD4G1guaQio69LnKHMpqksx2ENojKYlpcxJMOcbKbybs8Re4iMzTZ0Wzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh44n8Jn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5524606A325;
	Wed, 18 Nov 2026 22:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh44n8Jn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084071F000C4;
	Wed, 18 Nov 2026 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042729;
	bh=7fbk7iV1A5LF0N8W1B4j/3iH8CD6bp3+vKrifFEtIvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh44n8Jn2lgi2yNsKRfVEhCh3Kb1fKmBBfnfdf3oLCRNxhPKsZuNGba/suMY68dwM
	 WQY1M8djTnX3CzRV6P7T8e5YUlR3xbDT3yOVUhphPWnKPifh4OXxALSW8SFVUl5n9J
	 mn92dnSi+yRcZws/ek1h2hlTMTcL7gPiW1g1yLZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3273/3318] apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
Date: Wed, 18 Nov 2026 16:04:55 +0100
Message-ID: <20261118150457.806267724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8f1f7f664c1822af34c5465f9820b4e39146786b ]

When the namespace already exists, the reference taken by aa_get_ns() is
overwritten with ERR_PTR(-EEXIST) without being released. The caller in
apparmorfs.c clears ns on IS_ERR() and so cannot drop it either, leaking
the reference on raced mkdir of an existing namespace.

Release the reference before returning -EEXIST.

Fixes: 73688d1ed0b8 ("apparmor: refactor prepare_ns() and make usable from different views")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_ns.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_ns.c b/security/apparmor/policy_ns.c
index c70b69870fb72..abfccbd7d945b 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -302,10 +302,12 @@ struct aa_ns *__aa_find_or_create_ns(struct aa_ns *parent, const char *name,
 	/* try and find the specified ns */
 	/* released by caller */
 	ns = aa_get_ns(__aa_find_ns(&parent->sub_ns, name));
-	if (!ns)
+	if (!ns) {
 		ns = __aa_create_ns(parent, name, dir);
-	else
+	} else {
+		aa_put_ns(ns);
 		ns = ERR_PTR(-EEXIST);
+	}
 
 	/* return ref */
 	return ns;
-- 
2.53.0



