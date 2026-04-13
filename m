Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B738627BF79;
	Mon, 13 Apr 2026 16:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096364; cv=none; b=WlQ2UDFxYCnngjgCwQTUsQO8aHlYtUHBEu0ohnTKN75vL7j/HZnXQ3PiUv/3TL1jygAtEAisD/Nx8iw7j/7hBFkFHJzt8RBZ6boLHdn4X0pwYc3itEjkafriE922DfeHmU3aORF8BkElWPgf3O0TS48jS2llQcpZES5l0OEQG+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096364; c=relaxed/simple;
	bh=wek8uOez3AikuTUEy4rgG1sNaVLqDuH6CfGE249RNfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYisJVcx+LS9MwCXlF/wvV58DHA+BTN5biam8Ye8AAW9E26VkCOPIP4IQXVLjQMjMYtsL7xmhaXyo96otNYIfEKLIY+aZXEPhMZx9Ugfj/kwX6KQIuU9xhQLBzktHUrxxgIR42+Kq9x0SmAELeqEzs1hoXZ20HC4ro/11qyoc/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW8J6FnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW8J6FnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCD4C2BCAF;
	Mon, 13 Apr 2026 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096364;
	bh=wek8uOez3AikuTUEy4rgG1sNaVLqDuH6CfGE249RNfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW8J6FnQr/RNQfgseNQvok0akZ9KYNsbYU4YWD0YyzXcfBjORlrFyR3/zz1wSsT1p
	 HA4aWWUW/BhZh8fboTfnPuxeXj9qUeDbswf6rjPNO+CprscmclBBnTuvY3a2SYu9uu
	 h/iRPVyk6VIleFl9UfL4Oh1Y26zFe8K4gtfkXj5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Timmins <leotimmins1974@gmail.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 37/86] liveupdate: propagate file deserialization failures
Date: Mon, 13 Apr 2026 17:59:44 +0200
Message-ID: <20260413155732.952587537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Timmins <leotimmins1974@gmail.com>

commit 307e0c5859b0aecc34180468b1aa76684adcf539 upstream.

luo_session_deserialize() ignored the return value from
luo_file_deserialize().  As a result, a session could be left partially
restored even though the /dev/liveupdate open path treats deserialization
failures as fatal.

Propagate the error so a failed file deserialization aborts session
deserialization instead of silently continuing.

Link: https://lkml.kernel.org/r/20260325044608.8407-1-leotimmins1974@gmail.com
Link: https://lkml.kernel.org/r/20260325044608.8407-2-leotimmins1974@gmail.com
Fixes: 16cec0d26521 ("liveupdate: luo_session: add ioctls for file preservation")
Signed-off-by: Leo Timmins <leotimmins1974@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/luo_session.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -558,8 +558,13 @@ int luo_session_deserialize(void)
 		}
 
 		scoped_guard(mutex, &session->mutex) {
-			luo_file_deserialize(&session->file_set,
-					     &sh->ser[i].file_set_ser);
+			err = luo_file_deserialize(&session->file_set,
+						   &sh->ser[i].file_set_ser);
+		}
+		if (err) {
+			pr_warn("Failed to deserialize files for session [%s] %pe\n",
+				session->name, ERR_PTR(err));
+			return err;
 		}
 	}
 


