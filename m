Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17523264FF;
	Tue, 21 Jul 2026 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659303; cv=none; b=RO0+Tn+2/mtZ5O6f7eLbLWnhUiRpIVLELqmXHr/oEooPr90Mm8koi+Wn+j//diEHV03bpYNnCKka3wle7f3N+YuOW1YLj4cDuT5V4blTKIZ8+GrqzMx83CTHmzvkDxPiLAMru9r+s9VFciBASgHPnv8iYWXGf01tOq+52NuR4Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659303; c=relaxed/simple;
	bh=soia1T5U4oIl3F7NLvXfiYbA3PBNNX17bPhb2oIU8F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECLcifoGbva1HI2ydPT28avkWDunOihH2UvD7qEu5H7vFrXuTEMw2zDMTB/HmVv9iLHQSAVdlrOAWZTcforoD5S3XCy4L6/0TD4yi++MJ5GDf0x7G2FbGB3RC8dhFO8TQbg4FWTAhsU6uuXeArut81m1rfP+KnnfrP9JjzRvUpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gihy9xQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gihy9xQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6441F000E9;
	Tue, 21 Jul 2026 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659300;
	bh=vvsRHH0e2mm3UXUMyr5bv1wYqF0fI7cDNX4MbO9stfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gihy9xQxViZjmkqhfbbu9S6b9Tz9qP7RffHqtpY5Cyb8yoLI6e77XPoML0WnIHBYV
	 1H+p9fq4D4PW9CeHJjnyiw5c74lBrcvFm7gh+0iIthtMOtjzpP4IcmaHt7zSeYhEuv
	 20hVbbv/G6hINR6RxJTMcZWOq6mYXbFtaxZTjbPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Crystal Wood <crwood@redhat.com>
Subject: [PATCH 6.18 1468/1611] tracing/osnoise: Call synchronize_rcu() when unregistering
Date: Tue, 21 Jul 2026 17:26:24 +0200
Message-ID: <20260721152548.466646172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Crystal Wood <crwood@redhat.com>

commit fe58f457ad8d0a2bef4e053cfecca4b5cd266b1a upstream.

This ensures that any RCU readers traversing the instance list
have finished, before releasing the reference on the tracer that
the instance points to.

Cc: stable@vger.kernel.org
Fixes: a6ed2aee54644 ("tracing: Switch to kvfree_rcu() API")
Link: https://patch.msgid.link/20260609045430.1589786-1-crwood@redhat.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Crystal Wood <crwood@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -160,7 +160,9 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu_mightsleep(inst);
+	/* Do a full sync to ensure that tr remains valid, not just inst */
+	synchronize_rcu();
+	kvfree(inst);
 }
 
 /*


