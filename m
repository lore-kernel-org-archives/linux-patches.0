Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D943C1C68F;
	Mon,  4 May 2026 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904164; cv=none; b=Tv1nXOAdhbdlSpWLPV/wFzmEFzYn/3GxC6ZbOAeOSmbTwTV1NhLGUSqRgcRCgi1BR0WtR8EL35i3ra1eW1xhycNUPi7OI71VhMHawITaUh+9xt5EnS7y2vhgIwzoKc7JgS6ls4MA47AA6fLUaW1zL5Ik9l3LatljOVvAnOFSOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904164; c=relaxed/simple;
	bh=E0oWIvB0gcPjkm7hNz2OybmBZMMCWzHeoe6XOL0i/TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo6XowdWZu9qF6Z1xIYgXWH09XmYh76DwZNMs28MZmZOBu8jva5M89NHm2a5gaS9bN6jyp3XLWHxkZfyLb0NKFONxtUjP+G53ktoTqTBKkgNNNH+eTn7kzBsqESsdxou5LepNdOsaIzeCN2WgatTMLXZuGeC42jMrgO4LWAHsJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7tucQbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7tucQbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D91C2BCB8;
	Mon,  4 May 2026 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904164;
	bh=E0oWIvB0gcPjkm7hNz2OybmBZMMCWzHeoe6XOL0i/TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7tucQbWMocOM3u4J8cj/l+ClwGgfQ9eRHX1rVc7FBFdufjRu1WOSvVRCyGbXoRLZ
	 k0zGoe0EDEhAObG+bU7+feuYIhDbHT5SngKaSkxeUljjyH10pMgoKJYx6lbyJyj15d
	 Utvqnr/FaUJ5JzGO+vwnDbghvycH+/lccn/ig/cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gayatri Kammela <Gayatri.Kammela@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: [PATCH 6.18 209/275] x86/cpu: Disable FRED when PTI is forced on
Date: Mon,  4 May 2026 15:52:29 +0200
Message-ID: <20260504135150.841067653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 932d922285ef4d0d655a6f5def2779ae86ca0d73 upstream.

FRED and PTI were never intended to work together. No FRED hardware is
vulnerable to Meltdown and all of it should have LASS anyway.
Nevertheless, if you boot a system with pti=on and fred=on, the kernel
tries to do what is asked of it and dies a horrible death on the first
attempt to run userspace (since it never switches to the user page
tables).

Disable FRED when PTI is forced on, and print a warning about it.

A quick brain dump about what a FRED+PTI implementation would look like
is below. I'm not sure it would make any sense to do it, but never say
never. All I know is that it's way too complicated to be worth it today.

<brain dump>
The SWITCH_TO_USER/KERNEL_CR3 bits are simple to fix (or at least we
have the assembly tools to do it already), as is sticking the FRED entry
text in .entry.text (it's not in there today).

The nasty part is the stacks. Today, the CPU pops into the kernel on
MSR_IA32_FRED_RSP0 which is normal old kernel memory and not mapped to
userspace. The hardware pushes gunk on to MSR_IA32_FRED_RSP0, which is
currently the task stacks. MSR_IA32_FRED_RSP0 would need to point
elsewhere, probably cpu_entry_stack(). Then, start playing games with
stacks on entry/exit, including copying gunk to and from the task stack.

While I'd *like* to have PTI everywhere, I'm not sure it's worth mucking
up the FRED code with PTI kludges. If a user wants fast entry/exit, they
use FRED. If you want PTI (and sekuritay), you certainly don't care
about fast entry and FRED isn't going to help you *all* that much, so
you can just stay with the IDT.

Plus, FRED hardware should have LASS which gives you a similar security
profile to PTI without the CR3 munging.
</brain dump>

Reported-by: Gayatri Kammela <Gayatri.Kammela@amd.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260421163136.E7C6788A@davehans-spike.ostc.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -105,6 +105,11 @@ void __init pti_check_boottime_disable(v
 		pr_debug("PTI enabled, disabling INVLPGB\n");
 		setup_clear_cpu_cap(X86_FEATURE_INVLPGB);
 	}
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		pr_debug("PTI enabled, disabling FRED\n");
+		setup_clear_cpu_cap(X86_FEATURE_FRED);
+	}
 }
 
 static int __init pti_parse_cmdline(char *arg)


