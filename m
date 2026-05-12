Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C0F284883;
	Tue, 12 May 2026 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609528; cv=none; b=QJTLiWD9pzCVd/d0/O7ap4Dzyka3jKPpxqnk2n52ZJolby3Z7UMCLQP+npIrA89xVE89vDwzgndrEfDXv8ru1dB/c/oX6ANuh3GY1FZKOtbSnnYeSC5HIf84UrsBQn6YOpOC3Cznag/HEvK4OYgABCAyb4d7oqik3MTurfQpqS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609528; c=relaxed/simple;
	bh=s+YaETpaGxZRwcEDX7XgYjwRnZnSZVKetOLaCJOYiRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gzo9gGzmBaOqc9V/Pg6b6KZASKBLiAkcSr291ibd3HH+NYxBZTQSRAHCXWOpq0HQiIEAlcj+VEAU9PFP48/3w7yOgI4Z5zHQEZyTnfGTd+b8hJ5XZV8O2wA1+w1KVE++RkUvk0Web/eWGtf/rxR52GoblgBMqf53zJpOZRECs44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvC0HJFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvC0HJFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F3DC2BCC7;
	Tue, 12 May 2026 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609527;
	bh=s+YaETpaGxZRwcEDX7XgYjwRnZnSZVKetOLaCJOYiRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvC0HJFtTYH90O+PX11vAAGry+eF7AdBdk+xCOt6jGgcapWKKaj6jnOkq/T93kfW4
	 JEWgsdidLUtt81CfAJQv/CICBaWEjEA4ksmJbkQtumX04VcMBUL/iDC0qUU8WcXrJ6
	 uaOGlEol4/tBW6xKMHDnnZAdFhautkjDDAZMmSl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 230/307] perf/x86/intel: Enable auto counter reload for DMR
Date: Tue, 12 May 2026 19:40:25 +0200
Message-ID: <20260512173944.973726874@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit aa4384bc8f4360167f3c3d5322121fe892289ea2 upstream.

Panther cove µarch starts to support auto counter reload (ACR), but the
static_call intel_pmu_enable_acr_event() is not updated for the Panther
Cove µarch used by DMR. It leads to the auto counter reload is not
really enabled on DMR.

Update static_call intel_pmu_enable_acr_event() in intel_pmu_init_pnc().

Fixes: d345b6bb8860 ("perf/x86/intel: Add core PMU support for DMR")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430002558.712334-5-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -7525,6 +7525,7 @@ static __always_inline void intel_pmu_in
 	hybrid(pmu, event_constraints) = intel_pnc_event_constraints;
 	hybrid(pmu, pebs_constraints) = intel_pnc_pebs_event_constraints;
 	hybrid(pmu, extra_regs) = intel_pnc_extra_regs;
+	static_call_update(intel_pmu_enable_acr_event, intel_pmu_enable_acr);
 }
 
 static __always_inline void intel_pmu_init_skt(struct pmu *pmu)


