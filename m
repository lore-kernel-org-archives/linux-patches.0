Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0422425783A;
	Wed, 28 Jan 2026 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616039; cv=none; b=KRocwd1S1zSwwBddFpNYLEpcmjkvngjwU0fBs4ZLfOESSXcloiz/Du/Juo+cnXbNSR2K6dQG1Kw6rwDitHnUNG+ipONhXVez5ghGmpwf/qc2n8soDhZVYtT5Pi9AriSzK/akr1GkmFY6Yaukx2X0Pav6eVkix41vGKIheKhzVJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616039; c=relaxed/simple;
	bh=lv6hyZo/1nUucbxOewYmwFrKaulpqxN9kEfsgtDfoBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjieO3B+3YU0EpWzUEoXub8yoi1vHDp4vvXOBO3eF+uoMtx4LsE5NlIeB5OKXBbUUA5BIAsLOZiAVdBa3CL1Z39jlLE6GpXOcgg/BK09u5lOMt7xDX/VS5DRPUvawxWBeGb+EEzJ/cbjjNaWxfUd85qsMMlZJLCHVTQn71yw9jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk9AlHsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk9AlHsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EDEC4CEF1;
	Wed, 28 Jan 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616038;
	bh=lv6hyZo/1nUucbxOewYmwFrKaulpqxN9kEfsgtDfoBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk9AlHsIvwlZrHMLO5A/0TCI2O5JNpi/S55DrScT1HchpqBwoAKHcw72cVOjbJDbx
	 byJ40oCjOPs9zrfGd92oh9Y0mVH+jzhFIm4t8sG6swIJhgI399hHBtzD4/JuOLFgpU
	 4DUQ3e0L8ekbGrx5aq0aONMQn9bnjtZZmt+XDmHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.18 188/227] mei: trace: treat reg parameter as string
Date: Wed, 28 Jan 2026 16:23:53 +0100
Message-ID: <20260128145351.210987023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 06d5a7afe1d0b47102936d8fba568572c2b4b941 upstream.

The commit
afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
forbids to emit event with a plain char* without a wrapper.

The reg parameter always passed as static string and wrapper
is not strictly required, contrary to dev parameter.
Use the string wrapper anyway to check sanity of the reg parameters,
store it value independently and prevent internal kernel data leaks.

Since some code refactoring has taken place, explicit backporting may
be needed for kernels older than 6.10.

Cc: stable@vger.kernel.org  # v6.11+
Fixes: a0a927d06d79 ("mei: me: add io register tracing")
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260111145125.1754912-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/mei-trace.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/misc/mei/mei-trace.h
+++ b/drivers/misc/mei/mei-trace.h
@@ -21,18 +21,18 @@ TRACE_EVENT(mei_reg_read,
 	TP_ARGS(dev, reg, offs, val),
 	TP_STRUCT__entry(
 		__string(dev, dev_name(dev))
-		__field(const char *, reg)
+		__string(reg, reg)
 		__field(u32, offs)
 		__field(u32, val)
 	),
 	TP_fast_assign(
 		__assign_str(dev);
-		__entry->reg  = reg;
+		__assign_str(reg);
 		__entry->offs = offs;
 		__entry->val = val;
 	),
 	TP_printk("[%s] read %s:[%#x] = %#x",
-		  __get_str(dev), __entry->reg, __entry->offs, __entry->val)
+		  __get_str(dev), __get_str(reg), __entry->offs, __entry->val)
 );
 
 TRACE_EVENT(mei_reg_write,
@@ -40,18 +40,18 @@ TRACE_EVENT(mei_reg_write,
 	TP_ARGS(dev, reg, offs, val),
 	TP_STRUCT__entry(
 		__string(dev, dev_name(dev))
-		__field(const char *, reg)
+		__string(reg, reg)
 		__field(u32, offs)
 		__field(u32, val)
 	),
 	TP_fast_assign(
 		__assign_str(dev);
-		__entry->reg = reg;
+		__assign_str(reg);
 		__entry->offs = offs;
 		__entry->val = val;
 	),
 	TP_printk("[%s] write %s[%#x] = %#x",
-		  __get_str(dev), __entry->reg,  __entry->offs, __entry->val)
+		  __get_str(dev), __get_str(reg),  __entry->offs, __entry->val)
 );
 
 TRACE_EVENT(mei_pci_cfg_read,
@@ -59,18 +59,18 @@ TRACE_EVENT(mei_pci_cfg_read,
 	TP_ARGS(dev, reg, offs, val),
 	TP_STRUCT__entry(
 		__string(dev, dev_name(dev))
-		__field(const char *, reg)
+		__string(reg, reg)
 		__field(u32, offs)
 		__field(u32, val)
 	),
 	TP_fast_assign(
 		__assign_str(dev);
-		__entry->reg  = reg;
+		__assign_str(reg);
 		__entry->offs = offs;
 		__entry->val = val;
 	),
 	TP_printk("[%s] pci cfg read %s:[%#x] = %#x",
-		  __get_str(dev), __entry->reg, __entry->offs, __entry->val)
+		  __get_str(dev), __get_str(reg), __entry->offs, __entry->val)
 );
 
 #endif /* _MEI_TRACE_H_ */


