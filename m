Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E0C2F12D1;
	Fri, 17 Oct 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714576; cv=none; b=Zqjav+Z2wQGTrb11Z+djpW1K67ovqGAesnmKQOcvQRlnmJ0CSW4iVSrpIp3LrtziszDvZ8Ojq7EHKGj6qPglNT0Qo7eVj2xvgZR3j9HWT+995PilhS059kneSqBZhU3l+neryAvg0n7BYorrXRVMVw6QJntYzaBRbD9O2E17rwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714576; c=relaxed/simple;
	bh=Bh+ryoqV0Io3w698RKQsoZQannSlch7/hLTHGGYvGxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNUkZHIrTAN2eUgVUR21f7kg+9snhTqp1i/tSTvDLxZxW1KUAKZb9BWKxJu0QH7EIDLTAvXJ1kx3N/1coVkZFWU22WR2up48z0LvRiI44FxLq/dvPzg0R0f4sRkabgDSJvlzw4wfZeXsHgMAXQe4ZfUfPOo1IopY1jET0ZwKpCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=va/TZ9vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="va/TZ9vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2545FC4CEE7;
	Fri, 17 Oct 2025 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714576;
	bh=Bh+ryoqV0Io3w698RKQsoZQannSlch7/hLTHGGYvGxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=va/TZ9vIbPdXfGU5Yjd+coKLIcwI9b+bf0Blk33Jj9e6h59wQVzXCxHxrLFFZnYXY
	 kn/a+CEv9/pIMBSrk091f0cUBSMNzQa4nhspO1UNcBOMC5gLS7ynxKRgp6PerG5WDw
	 DLC+wpb6qdaONF3Ln+lfKWee4cVsFEVIqqAqTUiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH 6.12 193/277] x86/fred: Remove ENDBR64 from FRED entry points
Date: Fri, 17 Oct 2025 16:53:20 +0200
Message-ID: <20251017145154.166574506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Xin Li (Intel) <xin@zytor.com>

commit 3da01ffe1aeaa0d427ab5235ba735226670a80d9 upstream.

The FRED specification has been changed in v9.0 to state that there
is no need for FRED event handlers to begin with ENDBR64, because
in the presence of supervisor indirect branch tracking, FRED event
delivery does not enter the WAIT_FOR_ENDBRANCH state.

As a result, remove ENDBR64 from FRED entry points.

Then add ANNOTATE_NOENDBR to indicate that FRED entry points will
never be used for indirect calls to suppress an objtool warning.

This change implies that any indirect CALL/JMP to FRED entry points
causes #CP in the presence of supervisor indirect branch tracking.

Credit goes to Jennifer Miller <jmill@asu.edu> and other contributors
from Arizona State University whose research shows that placing ENDBR
at entry points has negative value thus led to this change.

Note: This is obviously an incompatible change to the FRED
architecture.  But, it's OK because there no FRED systems out in the
wild today. All production hardware and late pre-production hardware
will follow the FRED v9 spec and be compatible with this approach.

[ dhansen: add note to changelog about incompatibility ]

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Link: https://lore.kernel.org/linux-hardening/Z60NwR4w%2F28Z7XUa@ubun/
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250716063320.1337818-1-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64_fred.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -16,7 +16,7 @@
 
 .macro FRED_ENTER
 	UNWIND_HINT_END_OF_STACK
-	ENDBR
+	ANNOTATE_NOENDBR
 	PUSH_AND_CLEAR_REGS
 	movq	%rsp, %rdi	/* %rdi -> pt_regs */
 .endm


