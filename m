Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0641E1A2D;
	Wed, 19 Feb 2025 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954623; cv=none; b=qy00PkyBlAERhVHWSPhXOLP6IxnAb5aE6dAzlDhLhxu5oA7qQ/EybSa4pYOHOjRIsu+O2XEcfRBXGum9nShruHpe2woYJwVwToTsXx2A8SqzI4SMNu1aaEn8YNyo+dyFqjkiAHAdhlPiibHPJCojUkJ+5xp+VHXQcN8lJYN4bnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954623; c=relaxed/simple;
	bh=UljW5rxwjbcw/MJQp3wL0dO5KT9JCsBnJtgkI3c0KkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLKUTq2mS92ugdQXWZR5D9pp0bteRgce6pmMWAmhgXNEOPoNoUjwcraseucmkxbMQyWTSJR1g3vISfjO/TTmWoh1rVxOtS/Eik+UGga7sEUxTGaDu1jpC1U5cLDIwKlbc6G0NdyZabj0Uu4317T51Uzy61wHM1TILX5xpIGTOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mv57CGSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mv57CGSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBEC4CED1;
	Wed, 19 Feb 2025 08:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954623;
	bh=UljW5rxwjbcw/MJQp3wL0dO5KT9JCsBnJtgkI3c0KkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv57CGSkUHarsAibi5oC+OZ0evcx/XZXRrtJaXFU0zvBc21/rqkqKzkjeWzduwFFl
	 5xpqwKmz+v1JLy+2gDC+/H/gnf8XriRJEQYQSKmC5aL0m7m9InAgGOMWllk5yitmt1
	 PQNo4HvpTJKNWhb/Ti/vm6wgY0wdeGoTpx+qIp5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	intel-xe@lists.freedesktop.org,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 6.13 261/274] drm/xe/tracing: Fix a potential TP_printk UAF
Date: Wed, 19 Feb 2025 09:28:35 +0100
Message-ID: <20250219082619.803108290@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 07089083a526ea19daa72a1edf9d6e209615b77c upstream.

The commit
afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
exposes potential UAFs in the xe_bo_move trace event.

Fix those by avoiding dereferencing the
xe_mem_type_to_name[] array at TP_printk time.

Since some code refactoring has taken place, explicit backporting may
be needed for kernels older than 6.10.

Fixes: e46d3f813abd ("drm/xe/trace: Extract bo, vm, vma traces")
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-xe@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.11+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241223134250.14345-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_trace_bo.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_trace_bo.h
+++ b/drivers/gpu/drm/xe/xe_trace_bo.h
@@ -55,8 +55,8 @@ TRACE_EVENT(xe_bo_move,
 	    TP_STRUCT__entry(
 		     __field(struct xe_bo *, bo)
 		     __field(size_t, size)
-		     __field(u32, new_placement)
-		     __field(u32, old_placement)
+		     __string(new_placement_name, xe_mem_type_to_name[new_placement])
+		     __string(old_placement_name, xe_mem_type_to_name[old_placement])
 		     __string(device_id, __dev_name_bo(bo))
 		     __field(bool, move_lacks_source)
 			),
@@ -64,15 +64,15 @@ TRACE_EVENT(xe_bo_move,
 	    TP_fast_assign(
 		   __entry->bo      = bo;
 		   __entry->size = bo->size;
-		   __entry->new_placement = new_placement;
-		   __entry->old_placement = old_placement;
+		   __assign_str(new_placement_name);
+		   __assign_str(old_placement_name);
 		   __assign_str(device_id);
 		   __entry->move_lacks_source = move_lacks_source;
 		   ),
 	    TP_printk("move_lacks_source:%s, migrate object %p [size %zu] from %s to %s device_id:%s",
 		      __entry->move_lacks_source ? "yes" : "no", __entry->bo, __entry->size,
-		      xe_mem_type_to_name[__entry->old_placement],
-		      xe_mem_type_to_name[__entry->new_placement], __get_str(device_id))
+		      __get_str(old_placement_name),
+		      __get_str(new_placement_name), __get_str(device_id))
 );
 
 DECLARE_EVENT_CLASS(xe_vma,


