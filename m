Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2919F47143C;
	Tue, 21 Jul 2026 20:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664174; cv=none; b=KJzeoL8Lu8k5NRE43zf0NS4KQflVbAnCJfN4w5yFebwKXwaQWLrp1nM3noAT0Ewx+O05RG9PbOQn/qGMJ2sc9S/AqUyrfzUMqnm6Dv9dPkUTrOPfAuHCA+fW3pV1PmBqdy9x9J+jLLdBS50DuNLzgt5IvkRr1w0VME45zIrYsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664174; c=relaxed/simple;
	bh=572GHXuc4GjRdhjtSMLAe8gVhLZzSfIMGT4A6/Lf/dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8TSsGIsTLYIN7f4/GLRN2EdZ6Va1nNM5ZhyEIcf8FUY0JCaXQX9kWNoXci8ziKbvHPi8RClPi/gkUYzKhG+oZ+qTGyF8rLRFhXg5KtAixb4GQB+vVyCqezMOvR5uPO415QC+ntUe6Acggmn1eQpgOk/8l9GA9Ij2JDEXhj0Vv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJcoDOo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJcoDOo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A21F000E9;
	Tue, 21 Jul 2026 20:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664173;
	bh=dBpUJuhu2WjIYnsBXSbJVG5FUSVYMZSJnjgkpywd3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJcoDOo7pwmySpPVetL5Rd4Ua62UpKauN/qDmB8Cw+W3TYSIdtaHzT2kBHs8/73ki
	 NRw8PQ6O+zbJhR1p8NMB3ktaasIj1HgAPz8bagLcURIaSFjUIkBOejeWOvPhyEOHpf
	 tB1CDOwXWSn654A8DQEvWAlZR7ezXICrjfQd2qJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Crystal Wood <crwood@redhat.com>
Subject: [PATCH 6.12 1099/1276] tracing/osnoise: Call synchronize_rcu() when unregistering
Date: Tue, 21 Jul 2026 17:25:42 +0200
Message-ID: <20260721152510.581951657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -159,7 +159,9 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu_mightsleep(inst);
+	/* Do a full sync to ensure that tr remains valid, not just inst */
+	synchronize_rcu();
+	kvfree(inst);
 }
 
 /*


