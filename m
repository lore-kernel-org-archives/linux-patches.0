Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881245111B5;
	Wed, 30 Sep 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786051; cv=none; b=qvrJHvw16NA98U4Z6ylFF33O12E1HmSIYPj7fjGEe1d1beVlFDftwVn4a55GEcoUCrU/Sr8ft7BnwKxOw2EgoA2JM04K1ihDBkeaq1qZpofuf4Wi3NtgoAL0krJljKe5lN9dTO9jTOK7oF8ozrGeLVv4AkPuTsy/AmGGXDf4vl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786051; c=relaxed/simple;
	bh=4XHLEw1dZzxHrXdCHZw/JKkO75/UW+rRb9GxmEgcOuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZgbI9QqhA8vQuLxFTwis/7arr/q/fzeXlCkI7SbW55Km9cMzuiXdMPC6D+TAogoTUN4Gi77Ot6dnRo7ji6soFhfw2CQvVPp3nI7htmEJE65DFCtklqaubxQI0Ysr6TRRq5kzBVTTlMG6Uri9gRIaMl5ehyOdbdxiMQCKDEuSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjOklqxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjOklqxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9AC1F000FF;
	Wed, 30 Sep 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786050;
	bh=dtLXOJXWG0PH4WQH2R1fVXe7CNsujcQRjDwQdr/9/cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjOklqxwoNbA3mkAcCUJUFsHp9BYgVK7xmFhmUuo6Pv89VBu2+jVBm/N76fDym1fh
	 0lPHuc/c0IONXNY5W53Yny+QohjySV0rDPhsOCAVMG5gmOopR2s6TGIezhd1U2zNiH
	 N5NL+BA9gKm2yOwSUBY8pE5NmvGMH093h578JReY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 724/982] keys: translate request_key_auth pid for the reading procfs instance
Date: Wed, 30 Sep 2026 17:24:20 +0200
Message-ID: <20260930152432.301428566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 0d6a4268b06084baafd8ee5d66955c7e1c2e053b upstream.

request_key_auth_describe() prints rka->pid into /proc/keys as a raw
pid_t in the initial pid namespace. A reader can open /proc/keys through
a mount in another pid namespace. That reader sees a number with no
meaning there. The number can even name an unrelated task. The line
needs VIEW on the key. So the reader either shares the key owner's uid
or possesses the key.

The fix keeps a struct pid. Commit 4f82f45730c6 ("net ip6 flowlabel:
Make owner a union of struct pid * and kuid_t") gave
/proc/net/ip6_flowlabel the same storage. The print goes through
pid_nr_ns(). It renders against the pid namespace of the procfs instance
the line is read through. Commit ad08978ab41c ("ipv6/flowlabel: simplify
pid namespace lookup") moved that print to the same anchor. Output
through an initial namespace /proc does not change. The line shows 0 for
a requestor with no number in that namespace.

Translating at read time was the alternative. find_pid_ns() can resolve
a recycled number. The line would then name a live task with no
connection to the key. A stored struct pid gives 0 instead when the
requestor has no number there.

Link: https://lore.kernel.org/keyrings/20260809110202.2180410-1-maoyixie.tju@gmail.com/
Fixes: 78b7280cce23 ("KEYS: Improve /proc/keys")
Cc: stable@vger.kernel.org # v5.10+
Assisted-by: Claude:claude-opus-5 codeql
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://lore.kernel.org/r/20260821095935.1864998-1-maoyixie.tju@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/keys/request_key_auth-type.h |    2 +-
 security/keys/request_key_auth.c     |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/include/keys/request_key_auth-type.h
+++ b/include/keys/request_key_auth-type.h
@@ -22,7 +22,7 @@ struct request_key_auth {
 	const struct cred	*cred;
 	void			*callout_info;
 	size_t			callout_len;
-	pid_t			pid;
+	struct pid		*pid;
 	char			op[8];
 } __randomize_layout;
 
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -9,6 +9,8 @@
 
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/pid.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -73,7 +75,10 @@ static void request_key_auth_describe(co
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
 	if (key_is_positive(key))
-		seq_printf(m, " pid:%d ci:%zu", rka->pid, rka->callout_len);
+		seq_printf(m, " pid:%d ci:%zu",
+			   pid_nr_ns(rka->pid,
+				     proc_pid_ns(file_inode(m->file)->i_sb)),
+			   rka->callout_len);
 }
 
 /*
@@ -113,6 +118,7 @@ static void free_request_key_auth(struct
 	if (rka->cred)
 		put_cred(rka->cred);
 	kfree(rka->callout_info);
+	put_pid(rka->pid);
 	kfree(rka);
 }
 
@@ -226,14 +232,14 @@ struct key *request_key_auth_new(struct
 
 		irka = cred->request_key_auth->payload.data[0];
 		rka->cred = get_cred(irka->cred);
-		rka->pid = irka->pid;
+		rka->pid = get_pid(irka->pid);
 
 		up_read(&cred->request_key_auth->sem);
 	}
 	else {
 		/* it isn't - use this process as the context */
 		rka->cred = get_cred(cred);
-		rka->pid = current->pid;
+		rka->pid = get_pid(task_pid(current));
 	}
 
 	rka->target_key = key_get(target);


