Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947103EC6AE;
	Fri,  4 Sep 2026 05:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500451; cv=none; b=eaqq5Cmz1o/bmF2qYoHZzuU+fIgF2eGAuhGAdeHQjpSCTEkFHxJFCmyebAfgKMh1Pgpd6EDqjr1L9r7oqNOHA1AZXbre0b4grpeXMhmZrtEayfqmyIggti77DQ4d3kqGdhn/ni47Jz8u5thudn88Z63ulcxG+oEV+IrLv3CAJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500451; c=relaxed/simple;
	bh=nT+vpiXFzDNv0PJqotVtJmOJYRr61by/Xgg3kd/B4lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8BplG64dPfl/2CpiUn+2yygn1wQwThInfx2rs+k+cvv3YlUGY4TMVkZC0NuMt9XAjF+56/mxhLWxzwZfZmq25gGQs9kPob4gY1bOxFtNdOnFWSynT5cD8Z/fsZSzNeq1MXeqqQXM3sWTOVM02EKutDPJFOY5XSeLfQJQ8Achuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnBX63pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnBX63pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8C61F00A3D;
	Fri,  4 Sep 2026 05:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500450;
	bh=BWTAmNVfIptjy9diYV0IHrS/ZCIDEm572y/51rerAvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnBX63pX0+i7Snm34P7zYvEdLNOIgCJOiCaSEV3S3thzhybpCn0uFoaF2NXOo2yeS
	 CdwcNBHfJXEV3yTc2Y1uysGzUa/MJZFNZbh9lJfdTIBoeesk0+yM+C9Bivs2d2jle9
	 cm64E3MUni4rm7aFOPSP2G2bIzatoEi9cYamVTCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 060/552] tracing: Fix logged instance name on creation failure
Date: Fri,  4 Sep 2026 06:53:37 +0200
Message-ID: <20260904045749.207724887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

commit a9a01be2834a529cbd490ccbab02643f0c1735f2 upstream.

When boot instance creation fails, the kernel incorrectly logs "(null)"
as the instance name because strsep() consumes curr_str entirely during
parsing.

Print the properly parsed name variable instead. And while at it log
the error code.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807085423.4175161-1-vdonnefort@google.com
Fixes: cb1f98c5e574 ("tracing: Add creation of instances at boot command line")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -11172,7 +11172,8 @@ __init static void enable_instances(void
 
 		tr = trace_array_create_systems(name, NULL, addr, size);
 		if (IS_ERR(tr)) {
-			pr_warn("Tracing: Failed to create instance buffer %s\n", curr_str);
+			pr_warn("Tracing: Failed to create instance buffer '%s' (%ld)\n", name,
+				PTR_ERR(tr));
 			continue;
 		}
 


