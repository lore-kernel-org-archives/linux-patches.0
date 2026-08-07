Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB353382C5;
	Fri,  7 Aug 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114344; cv=none; b=dtq2YICW02IPSVUWhGIi+WNVj08Jh2mElE15Xs3NpuH45TYJiL8nGUJdQMuNRAWUeU2c4O7eu49Q7unfwmN7+mMFYxZdCWV+MQuHAd0q/7JcV0Hgg7VZgdBTZxBDeB0nsw016pgWQR12tVyAZF79DshAegqev+HMeSTVrinIbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114344; c=relaxed/simple;
	bh=n9RKF9LO/OFHjb+f3Gj3wnD+8zxqTC/rlpZhikQ9PBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDqtTyaJRh9O3tVyDBiCKruoh9LPMAtVbbVvTI2lQJGTF8NadxDx1jNDwKrMYFovy766fjMHJGh7oGXKYSd4Nb0/wArM8BSlzAQtlN3vMRTR42T7bi+CgerTuCG9as81+DVV5s5YQstO7eknuaFJjvczcmO48CCbvxEYElwUvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/rn3ePY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/rn3ePY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B901F000E9;
	Fri,  7 Aug 2026 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114342;
	bh=tSjfR1015LWPRlZ8OYmLySdh/pQvL2HrPBB2Sw6owv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/rn3ePYsEVza0x1533/8jDLsl5AXgYAE7myhSmTWQwAeHCu6YxxKFWe9a7p8kPNP
	 Ro3iWds2IyYDGsqfhL/NhBMGGKzfgUHh/saqia9IQqdo5DgsGLa2aDCgjB4fZE3Yfn
	 4o/yh+kmNlI5uKVwoRYQFzfYaAc1USevcDhfA82c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 231/337] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Fri,  7 Aug 2026 16:37:14 +0200
Message-ID: <20260807143423.560743932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit eb96c58907922546e415e545fe9a14ea63b02719 upstream.

Zero the allocated buffer in j1939_session_fresh_new() to ensure it
contains no residual data.

While there is a potential performance impact if users allocate maximum
sized ETP buffers, most real-world use cases are not noticeably affected
since the maximum known buffer size is typically around 65K.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Message-ID: <CAPAUci5dykCLjoijqkUtFqJFesgncrD7+S6y_V=gjbFkY2Tifg@mail.gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260728055835.1151785-3-o.rempel@pengutronix.de
Cc: stable@kernel.org
[mkl: add Message-ID]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1562,7 +1562,7 @@ j1939_session *j1939_session_fresh_new(s
 	}
 
 	/* alloc data area */
-	skb_put(skb, size);
+	skb_put_zero(skb, size);
 	/* skb is recounted in j1939_session_new() */
 	return session;
 }


