Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EF9215075;
	Thu, 20 Aug 2026 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248270; cv=none; b=fi/o7R7Mpob4QCUDABZH6CPtya1uX2Yu87JXjwHla89HA1tcuH8GtQuDxaAF8mMMSFeEpMlDtf2DrvzkEDyjPgAyXh5j0iUyvONxg+EMGVzhaAHrVbK3DxlqTErH8G4+B9aYzgHOVc9TRE8PSmNxXNE4lAGHRYwaYlGY1HYjcyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248270; c=relaxed/simple;
	bh=7UbPengbI0g1IU37f2VZK8yClUvPVl2xuV/L4H59NjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq6t2yFlZ1TlrhGqrJcM9dl3XNcQyRX9Q7csULv9ZffFqbvze6pWnC8996pP0VyMY9od6YOYFvu9kU/+/53kL7xqwwHdQJo3XRxHkiGiRN4PfWuRXJDk11GB1ahJ1BrCaRuM5Z782nIRugXOP20S2AD/oxBr9bZmKxPZPOPmWR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbmkAdxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbmkAdxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F263E1F000E9;
	Thu, 20 Aug 2026 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248269;
	bh=C9auzRduObGVbafAzVO6XtqcfaHgmLqM/8MCXsQVREE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbmkAdxHXAzah83J18qPTMAPxuHTOdW/TDF6CG2qHifKZ9Hg0hZXgFmiaSJDx+zon
	 DoDFy4Cr2uQ/8doD4D60UwZK19NGF1fftcASl4AfKuZCZIfGrC/aZ7oBKoqOBHoKBW
	 CUI/cARghQwxzei2mlfEZL2hUtQc5oi6q00Rhh5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Crystal Wood <crwood@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/303] tracing/osnoise: Call synchronize_rcu() when unregistering
Date: Thu, 20 Aug 2026 16:55:05 +0200
Message-ID: <20260820145258.383253950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crystal Wood <crwood@redhat.com>

[ Upstream commit fe58f457ad8d0a2bef4e053cfecca4b5cd266b1a ]

This ensures that any RCU readers traversing the instance list
have finished, before releasing the reference on the tracer that
the instance points to.

Cc: stable@vger.kernel.org
Fixes: a6ed2aee54644 ("tracing: Switch to kvfree_rcu() API")
Link: https://patch.msgid.link/20260609045430.1589786-1-crwood@redhat.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Crystal Wood <crwood@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -137,7 +137,9 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu_mightsleep(inst);
+	/* Do a full sync to ensure that tr remains valid, not just inst */
+	synchronize_rcu();
+	kvfree(inst);
 }
 
 /*


