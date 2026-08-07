Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C03C81B4;
	Fri,  7 Aug 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117172; cv=none; b=VkIqJDH5+iE84GXw0Vvaf7uXV0SuM6jFvmNufOWMdVVYy6EZt1It1hdl03pDoJuabGy+kPmVDZWu7GJwZUiYYU/Ye0p5I5OETDrq+HFIkNb/0GwkpZBGg+fcFZvlEsQthsvdmWh3nHTPyh0J7UBqj3zfO/FsGkYlu/u+74WVkik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117172; c=relaxed/simple;
	bh=BUagb2LeKQOKi8ep0iZq+1qmFmw6yfswzqlO+moQUKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOdexFB7eMbDxwvVaV96Xwnt/yQTb5vWY3Y6dVCDdF5zqFAV4lFMIJXHRDV/ziXrN4unxW6g6jXyeL30w7qkg7Er73hegVzLtTqLZxg6B7wY8Q4PhASraaXW3Wyh0TgzxYgfBoCe7Jv4WYsOXIXKkdwsXJ/gI+RoTgMkXJIOm9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qn3Gf8i1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qn3Gf8i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C541F000E9;
	Fri,  7 Aug 2026 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117171;
	bh=uUwWve+bdwvFEwyaHx1hgISjUHkv17OvqSwnqcvmsAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qn3Gf8i1RJJ5h/tzWe7BkX8VX3MdCkfI3oyfxDFHy9w8eO7cdEENivHKANa2tcm3Q
	 qyNgUhabRp3LKyMQ1CmJfrzcaAk4JSLuh0F20YS8tFYSn0X1Ulefn1dOtbcANku6d4
	 NKzt+IkESZRwmScisrgEAwq0vwdDRt6Dg/MfWhc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 226/438] tracing/fprobe: Roll back on enable_trace_fprobe() failure
Date: Fri,  7 Aug 2026 16:37:02 +0200
Message-ID: <20260807143432.822977897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raushan Patel <raushan.jhon@gmail.com>

commit aca0cd1bf16574327ef64f3178e5f5e37a61ef0b upstream.

enable_trace_fprobe() sets the file link or the TP_FLAG_PROFILE flag and
then registers each trace_fprobe in the probe list. If
__register_trace_fprobe() fails partway through, the function returns
immediately without unregistering the trace_fprobes it already registered
or undoing the file link / flag it set, leaving the event half-enabled and
leaking the registered fprobe(s).

enable_trace_kprobe() already handles this with a rollback path. Do the
same for fprobe: on failure, unregister all probes and clear the file link
or profile flag.

Link: https://lore.kernel.org/all/20260724064208.480030-1-raushan.jhon@gmail.com/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Cc: stable@vger.kernel.org
Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1481,11 +1481,21 @@ static int enable_trace_fprobe(struct tr
 		list_for_each_entry(tf, trace_probe_probe_list(tp), tp.list) {
 			ret = __register_trace_fprobe(tf);
 			if (ret < 0)
-				return ret;
+				goto err;
 		}
 	}
 
 	return 0;
+
+err:
+	/* Failed to enable one of them. Roll back all */
+	list_for_each_entry(tf, trace_probe_probe_list(tp), tp.list)
+		__unregister_trace_fprobe(tf);
+	if (file)
+		trace_probe_remove_file(tp, file);
+	else
+		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
+	return ret;
 }
 
 /*


