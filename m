Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8809D143C5F;
	Tue, 23 Apr 2024 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908770; cv=none; b=fY/LUDjRDQNOK/zk1CLwaPniUL+tou7qtJbAXbsEEs4zxL0g/favNiFJ21VHBQ2fIW3oTsxngky6uWag+5VPg7jPBnnaegpX2QuafDHu51bRy/ImK6l8O9b5yrqdNUZFeb8uVhmoWUlLXaDJpH3fOg7zYOE3HMjjHjjsIT/0xU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908770; c=relaxed/simple;
	bh=RAk9Jg+iL1v76WW4ztnlQh5YqpsIXVVHGDPjHGgV5HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs7DlSxK+IbFXf141ksYAdYUv20Vwtkddq+F4/OYIyy+osxGBH67KV7MUvGavhanZNGI0BoMu4QiW/R5l8dtUqv8nTDpBc8UKlWfZFMTuKS+fCyYn1X3fY9bdjuh/UvwTGSw+M1YCLHYklPMnkWNAYIslhD+98tVG1Lhjvm2d2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC9eZpPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC9eZpPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCA4C116B1;
	Tue, 23 Apr 2024 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908770;
	bh=RAk9Jg+iL1v76WW4ztnlQh5YqpsIXVVHGDPjHGgV5HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dC9eZpPm5fBJXNKRwijyjudtYZ1BQiAI3HHjDd8BHIz+fRXCmG46rB8eilD3lak7J
	 NufrhjC2U0e/P3drJdo0W40L9hvtr3gvMbDoodT3PJc7WU0bqXn30lRFiq5RrGwHPS
	 JpMN06NBlj+Y7Y5+j/yCpGt+90SWDSuuSo9ghwjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	stable@kernel.org
Subject: [PATCH 5.15 13/71] Revert "tracing/trigger: Fix to return error if failed to alloc snapshot"
Date: Tue, 23 Apr 2024 14:39:26 -0700
Message-ID: <20240423213844.574303826@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddh Raman Pant <siddh.raman.pant@oracle.com>

This reverts commit b5085b5ac1d96ea2a8a6240f869655176ce44197 which is
commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

The change has an incorrect assumption about the return value because
in the current stable trees for versions 5.15 and before, the following
commit responsible for making 0 a success value is not present:
b8cc44a4d3c1 ("tracing: Remove logic for registering multiple event triggers at a time")

The return value should be 0 on failure in the current tree, because in
the functions event_trigger_callback() and event_enable_trigger_func(),
we have:

	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
	/*
	 * The above returns on success the # of functions enabled,
	 * but if it didn't find any functions it returns zero.
	 * Consider no functions a failure too.
	 */
	if (!ret) {
		ret = -ENOENT;

Cc: stable@kernel.org # 5.15, 5.10, 5.4, 4.19
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1161,10 +1161,8 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	int ret = tracing_alloc_snapshot_instance(file->tr);
-
-	if (ret < 0)
-		return ret;
+	if (tracing_alloc_snapshot_instance(file->tr) != 0)
+		return 0;
 
 	return register_trigger(glob, ops, data, file);
 }


